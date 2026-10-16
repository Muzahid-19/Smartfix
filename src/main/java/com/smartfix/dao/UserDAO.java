package com.smartfix.dao;

import java.util.List;

import com.smartfix.modelcom.User;

public interface UserDAO {

    boolean registerUser(User user);

    User loginUser(String email, String password);

    User getUserById(int userId);

    User getUserByEmail(String email);

    List<User> getAllUsers();

    List<User> getAllAdmins();

    boolean updateUser(User user);

    boolean updatePasswordByEmail(String email, String password);

    boolean deleteUser(int userId);

    User getUserByEmailAndPassword(String email, String password);
}