package com.grownited.util;

import java.util.Locale;
import java.util.Set;

import org.springframework.web.multipart.MultipartFile;

public final class FileUploadValidator {

    private static final long MAX_SUBMISSION_FILE_SIZE = 25L * 1024L * 1024L;
    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of(
            "application/pdf",
            "text/plain",
            "application/zip",
            "application/x-zip-compressed",
            "image/png",
            "image/jpeg",
            "image/jpg",
            "video/mp4");

    private FileUploadValidator() {
    }

    public static void validateSubmissionFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return;
        }
        if (file.getSize() > MAX_SUBMISSION_FILE_SIZE) {
            throw new IllegalArgumentException("Submission file must be 25 MB or smaller.");
        }
        String contentType = file.getContentType() == null ? "" : file.getContentType().toLowerCase(Locale.ROOT);
        if (!ALLOWED_CONTENT_TYPES.contains(contentType)) {
            throw new IllegalArgumentException("Unsupported submission file type.");
        }

        String originalName = file.getOriginalFilename() == null ? "" : file.getOriginalFilename().toLowerCase(Locale.ROOT);
        if (originalName.endsWith(".exe") || originalName.endsWith(".bat") || originalName.endsWith(".cmd")
                || originalName.endsWith(".sh") || originalName.endsWith(".jar")) {
            throw new IllegalArgumentException("Executable files are not allowed.");
        }
    }
}