package com.cafe.erp.store.qsc;

import com.cafe.erp.store.qsc.dto.QscDTO;
import com.cafe.erp.store.qsc.dto.QscQuestionDTO;
import com.cafe.erp.store.qsc.dto.QscQuestionSearchDTO;
import com.cafe.erp.store.qsc.dto.QscSearchDTO;
import com.cafe.erp.util.ExcelUtil;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.Banner;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
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

    @GetMapping("list")
    public String qscList(QscSearchDTO searchDTO, Model model) throws Exception {
        List<QscDTO> qscList = qscService.qscList(searchDTO);
        model.addAttribute("list", qscList);
        model.addAttribute("pager", searchDTO);

        return "qsc/list";
    }

    @GetMapping("add")
    public String qscAdd(QscQuestionSearchDTO searchDTO, Model model) throws Exception {
        searchDTO.setSearchIsUse(true);
        searchDTO.setPerPage(100L);
        List<QscQuestionDTO> qscQuestionList = qscService.questionList(searchDTO);
        model.addAttribute("list", qscQuestionList);

        return "qsc/add";
    }

    @PostMapping("add")
    @ResponseBody
    public Map<String, Object> qscAdd(@RequestBody QscDTO qscDTO, Authentication authentication) throws Exception {
        Integer memberId = Integer.parseInt(authentication.getName());
        qscDTO.setMemberId(memberId);

        return result(qscService.addQsc(qscDTO));
    }

    @GetMapping("detail")
    public String qscDetail(Integer qscId, Model model) throws Exception {
        QscDTO qscDTO = qscService.qscDetail(qscId);
        model.addAttribute("dto", qscDTO);

        return "qsc/detail";
    }

    @GetMapping("/downloadExcel")
    public void downloadExcel(QscSearchDTO searchDTO, HttpServletResponse response) throws Exception {
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

    @GetMapping("admin/question")
    public String questionList(QscQuestionSearchDTO searchDTO, Authentication authentication, Model model) throws Exception {
        String memberId = authentication.getName();
        if (memberId.startsWith("2")) return "error/forbidden";

        List<QscQuestionDTO> questionList = qscService.questionList(searchDTO);
        model.addAttribute("list", questionList);
        model.addAttribute("pager", searchDTO);

        return "qsc/question_list";
    }

    @PostMapping("admin/question/add")
    @ResponseBody
    public Map<String, Object> addQuestion(@RequestBody QscQuestionDTO questionDTO) throws Exception {
        return result(qscService.addQuestion(questionDTO));
    }

    @PostMapping("admin/question/update")
    @ResponseBody
    public Map<String, Object> updateQuestion(@RequestBody QscQuestionDTO questionDTO) throws Exception {
        return result(qscService.updateQuestion(questionDTO));
    }

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
            response.put("message", "등록 완료");
            response.put("status", "success");
        } else {
            response.put("status", "error");
            response.put("message", "등록 실패");
        }

        return response;
    }

}
