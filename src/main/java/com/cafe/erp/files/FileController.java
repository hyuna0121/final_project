package com.cafe.erp.files;

import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;

@Controller
@RequestMapping("/fileDownload/")
public class FileController {
	
	@Value("${erp.upload.contract}")
	private String contractPath;

	@GetMapping("contract")
	public ResponseEntity<Resource> contractFile(@RequestParam String fileSavedName, @RequestParam String fileOriginalName) {
		try {
			Path filePath = Paths.get(contractPath).resolve(fileSavedName).normalize();
			Resource resource = new UrlResource(filePath.toUri());
			
			if (!resource.exists()) {
				return ResponseEntity.notFound().build();
			}
			
			String encodedOriginalName = UriUtils.encode(fileOriginalName, StandardCharsets.UTF_8);
            
            String contentDisposition = "attachment; filename=\"" + encodedOriginalName + "\"";

            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, contentDisposition)
                    .body(resource);
		} catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
	}
	
}
