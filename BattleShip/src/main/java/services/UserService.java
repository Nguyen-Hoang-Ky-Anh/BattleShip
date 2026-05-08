package services;

import dao.UserDao;
import models.User;

public class UserService {
    private final UserDao userDAO = new UserDao();

    public boolean register(User user){

        User existingUser =
                userDAO.findByEmail(user.getEmail());

        if(existingUser != null){
            return false;
        }

        userDAO.save(user);

        return true;
    }

    public User authenticate(String email,
                             String password){

        User user =
                userDAO.findByEmail(email);

        if(user == null){
            return null;
        }

        if(user.getPassword().equals(password)){
            return user;
        }

        return null;
    }
}
