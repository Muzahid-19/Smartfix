package com.smartfix.dao;

import java.util.List;

import com.smartfix.modelcom.Comment;

public interface CommentDAO {

    boolean addComment(Comment comment);

    Comment getCommentById(int commentId);

    List<Comment> getCommentsByComplaintId(int complaintId);

    boolean deleteComment(int commentId);
}