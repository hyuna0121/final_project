package com.cafe.erp.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class CustomErrorController implements ErrorController {

    @GetMapping("/error")
    public String handleError(HttpServletRequest request) {
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);

//        if (status != null) {
//            int statusCode = Integer.parseInt(status.toString());
//
//            switch (statusCode) {
//                case 403: return "error/403";
//                case 404: return "error/404";
//                case 500: return "error/500";
//                default: break;
//            }
//        }

        return "error/common";
    }

    @GetMapping("/error/noStoreInfo")
    public String noStoreInfo() { return "error/no_store_info"; }

}
