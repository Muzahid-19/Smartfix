
package com.smartfix.service.impl;

import java.util.List;

import com.smartfix.dao.UserDAO;
import com.smartfix.dao.impl.UserDAOImpl;
import com.smartfix.modelcom.User;
import com.smartfix.service.UserService;
import com.smartfix.utli.PasswordUtil;

public class UserServiceImpl implements UserService {

    private UserDAO userDAO;

    public UserServiceImpl() {
        userDAO = new UserDAOImpl();
    }

    @Override
    public boolean registerUser(User user) {

        if (user == null
                || user.getPassword() == null
                || user.getPassword().isEmpty()) {
            return false;
        }

        // Hash the password before storing the new user
        user.setPassword(
            PasswordUtil.hashPassword(user.getPassword())
        );

        return userDAO.registerUser(user);
    }

    @Override
    public User loginUser(String email, String password) {

        if (email == null || email.trim().isEmpty()
                || password == null || password.isEmpty()) {
            return null;
        }

        User user = userDAO.getUserByEmail(email.trim());

        if (user == null || user.getPassword() == null) {
            return null;
        }

        if (PasswordUtil.checkPassword(
                password, user.getPassword())) {
            return user;
        }

        return null;
    }

    @Override
    public User getUserById(int userId) {
        return userDAO.getUserById(userId);
    }

    @Override
    public User getUserByEmail(String email) {
        return userDAO.getUserByEmail(email);
    }

    @Override
    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    @Override
    public boolean updateUser(User user) {

        if (user == null || user.getUserId() <= 0) {
            return false;
        }

        return userDAO.updateUser(user);
    }

    @Override
    public boolean deleteUser(int userId) {
        return userDAO.deleteUser(userId);
    }

    @Override
    public User getUserByEmailAndPassword(
            String email, String password) {

        return loginUser(email, password);
    }
}
