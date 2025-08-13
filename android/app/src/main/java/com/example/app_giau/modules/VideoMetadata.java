package com.example.app_giau.modules;

public class VideoMetadata {
    public long id;
    public String filePath;
    public String fileName;
    public long fileSize; // byte
    public long dateAdded; // thời gian lưu
    public int duration; // thời lượng video (ms)

    // Các trường bổ sung cho SQLite
    public long createdAt;
    public String tags;
    public boolean isHidden;
    public long size;

    public VideoMetadata() {}

    // Constructor dùng khi load từ DB
    public VideoMetadata(long id, String filePath, String fileName, long fileSize, long dateAdded, int duration) {
        this.id = id;
        this.filePath = filePath;
        this.fileName = fileName;
        this.fileSize = fileSize;
        this.dateAdded = dateAdded;
        this.duration = duration;

        // Đồng bộ với các field bổ sung
        this.createdAt = dateAdded;
        this.size = fileSize;
    }

    // Constructor dùng khi ẩn video
    public VideoMetadata(String filePath, String fileName, long createdAt, String tags, boolean isHidden, long size) {
        this.filePath = filePath;
        this.fileName = fileName;
        this.createdAt = createdAt;
        this.tags = tags;
        this.isHidden = isHidden;
        this.size = size;

        // Đồng bộ với các field cũ
        this.dateAdded = createdAt;
        this.fileSize = size;
    }

    // Getter / Setter
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }

    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }

    public long getFileSize() { return fileSize; }
    public void setFileSize(long fileSize) { this.fileSize = fileSize; }

    public long getDateAdded() { return dateAdded; }
    public void setDateAdded(long dateAdded) { this.dateAdded = dateAdded; }

    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }

    public long getCreatedAt() { return createdAt; }
    public void setCreatedAt(long createdAt) { this.createdAt = createdAt; }

    public String getTags() { return tags; }
    public void setTags(String tags) { this.tags = tags; }

    public boolean isHidden() { return isHidden; }
    public void setHidden(boolean hidden) { isHidden = hidden; }

    public long getSize() { return size; }
    public void setSize(long size) { this.size = size; }
}
