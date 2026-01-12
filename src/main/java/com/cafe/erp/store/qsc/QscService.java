package com.cafe.erp.store.qsc;

import com.cafe.erp.store.qsc.dto.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class QscService {

    @Autowired
    private QscDAO qscDAO;

    public List<QscQuestionDTO> questionList(QscQuestionSearchDTO searchDTO) throws Exception {
        Long totalCount = qscDAO.questionCount(searchDTO);
        searchDTO.pageing(totalCount);
        return qscDAO.questionList(searchDTO);
    }

    public int addQuestion(QscQuestionDTO questionDTO) throws Exception {
        return qscDAO.addQuestion(questionDTO);
    }

    public List<QscQuestionDTO> excelQuestionList(QscQuestionSearchDTO searchDTO) throws Exception {
        return qscDAO.excelQuestionList(searchDTO);
    }

    public List<QscDTO> qscList(QscSearchDTO searchDTO) throws Exception {
        Long totalCount = qscDAO.qscCount(searchDTO);
        searchDTO.pageing(totalCount);
        return qscDAO.qscList(searchDTO);
    }

    @Transactional
    public int addQsc(QscDTO qscDTO) throws Exception {
        List<QscDetailDTO> qscDetailDTOS = qscDTO.getQscDetailDTOS();
        List<Integer> questionIds = qscDetailDTOS.stream()
                .map(QscDetailDTO::getListId)
                .collect(Collectors.toList());
        List<QscQuestionDTO> questionList = qscDAO.questionListById(questionIds);
        Map<Integer, Integer> maxScoreMap = questionList.stream()
                .collect(Collectors.toMap(QscQuestionDTO::getListId, QscQuestionDTO::getListMaxScore));

        int totalScore = 0;
        int maxScore = 0;
        for (QscDetailDTO detail: qscDetailDTOS) {
            totalScore += detail.getDetailScore();
            maxScore += maxScoreMap.getOrDefault(detail.getListId(), 0);
        }

        String grade = "D";
        double percent = 0.0;
        if (maxScore > 0) {
            percent = (double) totalScore / maxScore * 100;

            if (percent >= 90) grade = "A";
            else if (percent >= 80) grade = "B";
            else if (percent >= 70) grade = "C";
        }

        qscDTO.setQscQuestionTotalScore(maxScore);
        qscDTO.setQscTotalScore(totalScore);
        qscDTO.setQscGrade(grade);

        int result = qscDAO.addQsc(qscDTO);

        for (QscDetailDTO detail : qscDetailDTOS) {
            detail.setQscId(qscDTO.getQscId());
            qscDAO.addDetail(detail);
        }

        return result;
    }

    public QscDTO qscDetail(Integer qscId) throws Exception {
        return qscDAO.qscDetail(qscId);
    }

    public List<QscDTO> excelList(QscSearchDTO searchDTO) throws Exception {
        return qscDAO.excelList(searchDTO);
    }

    public int updateQuestion(QscQuestionDTO questionDTO) throws Exception {
        return qscDAO.updateQuestion(questionDTO);
    }
}
