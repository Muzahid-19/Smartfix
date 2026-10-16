package com.smartfix.service;

import java.util.List;

import com.smartfix.modelcom.User;

public interface UserService {

    boolean registerUser(User user);

    User loginUser(String email, String password);

    User getUserById(int userId);

    User getUserByEmail(String email);

    List<User> getAllUsers();

    boolean updateUser(User user);

    boolean deleteUser(int userId);

    User getUserByEmailAndPassword(
        String email,
        String password
    );
}