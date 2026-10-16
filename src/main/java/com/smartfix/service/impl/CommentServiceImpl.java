package com.smartfix.service.impl;

import java.util.List;

import com.smartfix.dao.CommentDAO;
import com.smartfix.dao.impl.CommentDAOImpl;
import com.smartfix.modelcom.Comment;
import com.smartfix.service.CommentService;

public class CommentServiceImpl implements CommentService {

    private CommentDAO commentDAO;

    public CommentServiceImpl() {
        commentDAO = new CommentDAOImpl();
    }

    @Override
    public boolean addComment(Comment comment) {
        return commentDAO.addComment(comment);
    }

    @Override
    public List<Comment> getCommentsByComplaintId(int complaintId) {
        return commentDAO.getCommentsByComplaintId(complaintId);
    }

    @Override
    public Comment getCommentById(int commentId) {
        return commentDAO.getCommentById(commentId);
    }
}