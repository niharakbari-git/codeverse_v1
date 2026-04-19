package com.grownited.service;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.cloudinary.Cloudinary;
import com.grownited.util.FileUploadValidator;

@Service
public class FileUploadService {

    private final Cloudinary cloudinary;

    public FileUploadService(Cloudinary cloudinary) {
        this.cloudinary = cloudinary;
    }

    public UploadedFile uploadSubmissionFile(MultipartFile file, Integer applicationId, Integer userId) {
        FileUploadValidator.validateSubmissionFile(file);
        if (file == null || file.isEmpty()) {
            return null;
        }

        try {
            String secureName = "submission-" + applicationId + "-" + userId + "-" + UUID.randomUUID().toString().replace("-", "");
            Map<String, Object> options = new HashMap<>();
            options.put("folder", "codeverse/submissions");
            options.put("public_id", secureName);
            options.put("resource_type", "auto");

            @SuppressWarnings("unchecked")
            Map<String, Object> result = (Map<String, Object>) cloudinary.uploader().upload(file.getBytes(), options);
            Object secureUrl = result.get("secure_url");
            if (secureUrl == null) {
                throw new IllegalStateException("Submission upload failed.");
            }
            return new UploadedFile(file.getOriginalFilename(), secureUrl.toString());
        } catch (Exception e) {
            throw new IllegalArgumentException("Unable to upload submission file right now.", e);
        }
    }

    public static class UploadedFile {
        private final String originalName;
        private final String url;

        public UploadedFile(String originalName, String url) {
            this.originalName = originalName;
            this.url = url;
        }

        public String getOriginalName() {
            return originalName;
        }

        public String getUrl() {
            return url;
        }
    }
}