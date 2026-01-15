package com.cafe.erp.store.qsc;

import com.cafe.erp.security.UserDTO;
import com.cafe.erp.store.StoreDTO;
import com.cafe.erp.store.StoreService;
import com.cafe.erp.store.qsc.dto.QscDTO;
import com.cafe.erp.store.qsc.dto.QscQuestionDTO;
import com.cafe.erp.store.qsc.dto.QscQuestionSearchDTO;
import com.cafe.erp.store.qsc.dto.QscSearchDTO;
import com.cafe.erp.util.ExcelUtil;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/store/qsc/")
public class QscController {

    @Autowired
    private QscService qscService;
    @Autowired
    private StoreService storeService;

    @GetMapping("list")
    public String qscList(QscSearchDTO searchDTO, Model model, @AuthenticationPrincipal UserDTO user) throws Exception {
        boolean isStoreOwner = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_STORE"));

        if (isStoreOwner) {
            if (user.getStore() == null) {
                return "error/no_store_info";
            }
            searchDTO.setSearchStoreId(user.getStore().getStoreId());
        }

        List<QscDTO> qscList = qscService.qscList(searchDTO);
        model.addAttribute("list", qscList);
        model.addAttribute("pager", searchDTO);

        return isStoreOwner ? "view_store/store/qsc_list" : "qsc/list";
    }

    @PreAuthorize("hasAnyRole('DEPT_SALES', 'EXEC', 'MASTER')")
    @GetMapping("add")
    public String qscAdd(QscQuestionSearchDTO searchDTO, Model model) throws Exception {
        searchDTO.setSearchIsUse(true);
        searchDTO.setPerPage(100L);
        List<QscQuestionDTO> qscQuestionList = qscService.questionList(searchDTO);
        model.addAttribute("list", qscQuestionList);

        return "qsc/add";
    }

    @PreAuthorize("hasAnyRole('DEPT_SALES', 'EXEC', 'MASTER')")
    @PostMapping("add")
    @ResponseBody
    public Map<String, Object> qscAdd(@RequestBody QscDTO qscDTO, @AuthenticationPrincipal UserDTO user) throws Exception {
        Integer writerId = user.getMember().getMemberId();
        boolean isSales = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_DEPT_SALES"));

        if (isSales) {
            boolean isManager = storeService.isCurrentManager(qscDTO.getStoreId(), writerId);
            if (!isManager) return result("해당 가맹점의 담당자가 아닙니다.");
        }

        qscDTO.setMemberId(writerId);

        return result(qscService.addQsc(qscDTO));
    }

    @GetMapping("detail")
    public String qscDetail(Integer qscId, Model model, @AuthenticationPrincipal UserDTO user) throws Exception {
        boolean isStoreOwner = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_STORE"));

        QscDTO qscDTO = qscService.qscDetail(qscId);
        if (qscDTO == null) return "error/404";
        if (isStoreOwner) {
            StoreDTO store = user.getStore();
            if (store == null) return "error/no_store_info";
            if (!store.getStoreId().equals(qscDTO.getStoreId())) return "error/403";
        }

        model.addAttribute("dto", qscDTO);

        return "qsc/detail";
    }

    @PreAuthorize("hasAnyRole('DEPT_SALES', 'EXEC', 'MASTER')")
    @GetMapping("edit")
    public String qscEdit(Integer qscId, Model model, @AuthenticationPrincipal UserDTO user) throws Exception {
        boolean isSales = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_DEPT_SALES"));
        QscDTO qscDTO = qscService.qscDetail(qscId);
        if (isSales && (user.getMember().getMemberId() != qscDTO.getMemberId())) return "error/403";

        model.addAttribute("dto", qscDTO);

        return "qsc/edit";
    }

    @PreAuthorize("hasAnyRole('DEPT_SALES', 'EXEC', 'MASTER')")
    @PostMapping("update")
    @ResponseBody
    public Map<String, Object> qscUpdate(@RequestBody QscDTO qscDTO, @AuthenticationPrincipal UserDTO user) throws Exception {
        boolean isSales = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_DEPT_SALES"));
        if (isSales) {
            QscDTO originQsc = qscService.qscDetail(qscDTO.getQscId());
            if (user.getMember().getMemberId() != originQsc.getMemberId()) return result("해당 QSC 점검의 담당자가 아닙니다.");
        }

        return result(qscService.updateQsc(qscDTO));
    }

    @GetMapping("/downloadExcel")
    public void downloadExcel(QscSearchDTO searchDTO, HttpServletResponse response, @AuthenticationPrincipal UserDTO user) throws Exception {
        boolean isStoreOwner = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_STORE"));

        if (isStoreOwner) {
            if (user.getStore() == null) {
                response.sendRedirect("/error/noStoreInfo");
                return;
            }
            searchDTO.setSearchStoreId(user.getStore().getStoreId());
        }

        List<QscDTO> list = qscService.excelList(searchDTO);
        String[] headers = {"ID", "가맹점명", "점주명", "가맹점주소", "점검담당자명", "제목", "점검일시", "만점", "총점", "환산점수", "등급", "종합의견"};

        ExcelUtil.download(list, headers, "QSC 목록", response, (row, dto) -> {
            row.createCell(0).setCellValue(dto.getQscId());
            row.createCell(1).setCellValue(dto.getStoreName());
            row.createCell(2).setCellValue(dto.getOwnerName());
            row.createCell(3).setCellValue(dto.getStoreAddress());
            row.createCell(4).setCellValue(dto.getMemName());
            row.createCell(5).setCellValue(dto.getQscTitle());
            row.createCell(6).setCellValue(dto.getQscDateStr());
            row.createCell(7).setCellValue(dto.getQscQuestionTotalScore());
            row.createCell(8).setCellValue(dto.getQscTotalScore());
            row.createCell(9).setCellValue(dto.getQscScore());
            row.createCell(10).setCellValue(dto.getQscGrade());
            row.createCell(11).setCellValue(dto.getQscOpinion());
        });
    }

    @PreAuthorize("hasRole('HQ')")
    @GetMapping("admin/question")
    public String questionList(QscQuestionSearchDTO searchDTO, Model model) throws Exception {
        List<QscQuestionDTO> questionList = qscService.questionList(searchDTO);
        model.addAttribute("list", questionList);
        model.addAttribute("pager", searchDTO);

        return "qsc/question_list";
    }

    @PreAuthorize("hasAnyRole('DEPT_SALES', 'EXEC', 'MASTER')")
    @PostMapping("admin/question/add")
    @ResponseBody
    public Map<String, Object> addQuestion(@RequestBody QscQuestionDTO questionDTO) throws Exception {
        return result(qscService.addQuestion(questionDTO));
    }

    @PreAuthorize("hasAnyRole('DEPT_SALES', 'EXEC', 'MASTER')")
    @PostMapping("admin/question/update")
    @ResponseBody
    public Map<String, Object> updateQuestion(@RequestBody QscQuestionDTO questionDTO) throws Exception {
        return result(qscService.updateQuestion(questionDTO));
    }

    @PreAuthorize("hasRole('HQ')")
    @GetMapping("question/downloadExcel")
    public void downloadExcelQuestion(QscQuestionSearchDTO searchDTO, HttpServletResponse response) throws Exception {
        List<QscQuestionDTO> list = qscService.excelQuestionList(searchDTO);
        String[] headers = {"ID", "카테고리", "질문", "배점", "사용여부"};

        ExcelUtil.download(list, headers, "QSC 질문 목록", response, (row, dto) -> {
            row.createCell(0).setCellValue(dto.getListId());
            row.createCell(1).setCellValue(dto.getListCategory());
            row.createCell(2).setCellValue(dto.getListQuestion());
            row.createCell(3).setCellValue(dto.getListMaxScore());
            row.createCell(4).setCellValue(dto.getListIsUseStr());
        });
    }

    private Map<String, Object> result(int result) {
        Map<String, Object> response = new HashMap<>();

        if (result > 0) {
            response.put("status", "success");
        } else {
            response.put("status", "fail");
        }

        return response;
    }

    private Map<String, Object> result(String message) {
        Map<String, Object> response = new HashMap<>();

        response.put("status", "error");
        response.put("message", message);

        return response;
    }

}
