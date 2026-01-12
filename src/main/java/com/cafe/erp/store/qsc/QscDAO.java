package com.cafe.erp.store.qsc;

import com.cafe.erp.store.qsc.dto.*;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface QscDAO {
    public List<QscQuestionDTO> questionList(QscQuestionSearchDTO searchDTO) throws Exception;

    public Long questionCount(QscQuestionSearchDTO searchDTO) throws Exception;

    public int addQuestion(QscQuestionDTO questionDTO) throws Exception;

    public List<QscQuestionDTO> excelQuestionList(QscQuestionSearchDTO searchDTO) throws Exception;

    public Long qscCount(QscSearchDTO searchDTO) throws Exception;

    public List<QscDTO> qscList(QscSearchDTO searchDTO) throws Exception;

    public  List<QscQuestionDTO> questionListById(List<Integer> questionIds) throws Exception;

    public int addQsc(QscDTO qscDTO) throws Exception;

    public int addDetail(QscDetailDTO detail) throws Exception;

    public QscDTO qscDetail(Integer qscId) throws Exception;

    public List<QscDTO> excelList(QscSearchDTO searchDTO) throws Exception;

    public int updateQuestion(QscQuestionDTO questionDTO) throws Exception;
}
