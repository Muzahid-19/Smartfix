package com.smartfix.service;

import java.util.List;

import com.smartfix.modelcom.Comment;

public interface CommentService {

    boolean addComment(Comment comment);

    List<Comment> getCommentsByComplaintId(int complaintId);

    Comment getCommentById(int commentId);
}