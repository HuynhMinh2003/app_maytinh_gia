package com.example.app_giau.modules;

public class ImageMetadata {
    public String filePath;
    public String fileName;
    public long createdAt;
    public String tags;
    public boolean isHidden;
    public long size;

    public ImageMetadata(String filePath, String fileName, long createdAt, String tags, boolean isHidden, long size) {
        this.filePath = filePath;
        this.fileName = fileName;
        this.createdAt = createdAt;
        this.tags = tags;
        this.isHidden = isHidden;
        this.size = size;
    }
}
