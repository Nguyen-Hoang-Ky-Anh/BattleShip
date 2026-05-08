package dao;

import models.User;

import java.util.ArrayList;
import java.util.List;

public class UserDao {
    private static final List<User> users = new ArrayList<>();

    public void save(User user) {
        users.add(user);
    }

    public User findByEmail(String email) {

        for(User user : users){

            if(user.getEmail().equals(email)){
                return user;
            }
        }

        return null;
    }
}
