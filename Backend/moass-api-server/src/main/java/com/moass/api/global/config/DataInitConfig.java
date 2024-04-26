package com.moass.api.global.config;

import com.moass.api.domain.user.entity.User;
import com.moass.api.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DataInitConfig implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        if (userRepository.count().block() == 0) {  // 비동기 처리에 맞게 block 사용
            insertUsers("Z001@com","9000001","1234");
            insertUsers("Z002@com","9000002","1234");
            insertUsers("Z003@com","9000003","1234");
            insertUsers("Z004@com","9000004","1234");
            insertUsers("Z005@com","9000005","1234");
            insertUsers("Z011@com","9000011","1234");
            insertUsers("Z012@com","9000012","1234");
            insertUsers("Z013@com","9000013","1234");
            insertUsers("Z014@com","9000014","1234");
            insertUsers("Z015@com","9000015","1234");
        }
    }

    private void insertUsers(String userEmail, String userId, String password) {
        User user = new User(userEmail, userId,passwordEncoder.encode(password));
        userRepository.saveForce(user).subscribe();  // 비동기 저장
    }
}
