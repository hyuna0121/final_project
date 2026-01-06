package com.cafe.erp.files;

import java.net.MalformedURLException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
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
	
	@Value("${erp.upload.profile}")
	private String profilePath;
	
	@Value("${erp.upload.voc}") 
    private String vocPath;

	@GetMapping("contract")
	public ResponseEntity<Resource> contractFile(@RequestParam String fileSavedName, @RequestParam String fileOriginalName) {
		return createDownloadResponse(contractPath, fileSavedName, fileOriginalName);
	}
	
	@GetMapping("profile")
    public ResponseEntity<Resource> Profile(@RequestParam String fileSavedName){
		return createImageResponse(profilePath, fileSavedName);
    }
	
	@GetMapping("vocImageDownload")
	public ResponseEntity<Resource> vocProcessFile(@RequestParam String fileSavedName, @RequestParam String fileOriginalName) {
		return createDownloadResponse(vocPath, fileSavedName, fileOriginalName);
	}
	
	@GetMapping("vocImage")
    public ResponseEntity<Resource> vocImageView(@RequestParam String fileSavedName) {
		return createImageResponse(vocPath, fileSavedName);
    }
	
	
	private ResponseEntity<Resource> createDownloadResponse(String basePath, String savedName, String originalName) {
        try {
            Resource resource = loadResource(basePath, savedName);
            if (resource == null || !resource.exists()) {
                return ResponseEntity.notFound().build();
            }

            String encodedOriginalName = UriUtils.encode(originalName, StandardCharsets.UTF_8);
            String contentDisposition = "attachment; filename=\"" + encodedOriginalName + "\"";

            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, contentDisposition)
                    .body(resource);

        } catch (Exception e) {
            e.printStackTrace();
            
            return ResponseEntity.internalServerError().build();
        }
    }

    private ResponseEntity<Resource> createImageResponse(String basePath, String savedName) {
        try {
            Resource resource = loadResource(basePath, savedName);
            if (resource == null || !resource.exists()) {
                return ResponseEntity.notFound().build();
            }

            String contentType = determineContentType(savedName);
            String encodedFileName = UriUtils.encode(savedName, StandardCharsets.UTF_8);

            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + encodedFileName + "\"")
                    .header(HttpHeaders.CONTENT_TYPE, contentType)
                    .body(resource);

        } catch (Exception e) {
            e.printStackTrace();
            
            return ResponseEntity.internalServerError().build();
        }
    }

    private Resource loadResource(String basePath, String fileName) throws MalformedURLException {
        Path filePath = Paths.get(basePath).resolve(fileName).normalize();
        
        return new UrlResource(filePath.toUri());
    }

    private String determineContentType(String fileName) {
        String lowerName = fileName.toLowerCase();
        
        if (lowerName.endsWith(".png")) return MediaType.IMAGE_PNG_VALUE;
        else if (lowerName.endsWith(".gif")) return MediaType.IMAGE_GIF_VALUE;
        else if (lowerName.endsWith(".webp")) return "image/webp";
   
        return MediaType.IMAGE_JPEG_VALUE;
    }
	
}
