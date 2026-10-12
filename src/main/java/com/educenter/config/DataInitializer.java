package com.educenter.config;

import com.educenter.entity.Role;
import com.educenter.entity.User;
import com.educenter.repository.RoleRepository;
import com.educenter.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;

    public DataInitializer(UserRepository userRepository,
                           RoleRepository roleRepository,
                           PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) throws Exception {
        // 1. Đảm bảo 3 Role luôn tồn tại
        Role adminRole = roleRepository.findByName("ROLE_ADMIN").orElseGet(() -> {
            Role r = new Role(null, "ROLE_ADMIN", "Quản trị viên hệ thống");
            return roleRepository.save(r);
        });

        Role teacherRole = roleRepository.findByName("ROLE_TEACHER").orElseGet(() -> {
            Role r = new Role(null, "ROLE_TEACHER", "Giáo viên");
            return roleRepository.save(r);
        });

        Role parentRole = roleRepository.findByName("ROLE_PARENT").orElseGet(() -> {
            Role r = new Role(null, "ROLE_PARENT", "Phụ huynh");
            return roleRepository.save(r);
        });

        // 2. Khởi tạo hoặc cập nhật mật khẩu 123456 chuẩn cho tài khoản admin
        User admin = userRepository.findByUsername("admin").orElseGet(() -> {
            User u = new User();
            u.setUsername("admin");
            u.setEmail("admin@educenter.edu.vn");
            u.setFullName("Quản Trị Viên EduCenter");
            u.setPhone("0988000001");
            u.setRole(adminRole);
            u.setActive(true);
            return u;
        });
        admin.setPassword(passwordEncoder.encode("123456"));
        admin.setActive(true);
        userRepository.save(admin);

        // 3. Khởi tạo hoặc cập nhật mật khẩu 123456 chuẩn cho tài khoản gv_toan
        User gv = userRepository.findByUsername("gv_toan").orElseGet(() -> {
            User u = new User();
            u.setUsername("gv_toan");
            u.setEmail("tranvantoan@educenter.edu.vn");
            u.setFullName("ThS. Trần Văn Toán");
            u.setPhone("0988000002");
            u.setRole(teacherRole);
            u.setActive(true);
            return u;
        });
        gv.setPassword(passwordEncoder.encode("123456"));
        gv.setActive(true);
        userRepository.save(gv);

        // 4. Khởi tạo hoặc cập nhật mật khẩu 123456 chuẩn cho tài khoản ph_dung
        User ph = userRepository.findByUsername("ph_dung").orElseGet(() -> {
            User u = new User();
            u.setUsername("ph_dung");
            u.setEmail("hoangtiendung@gmail.com");
            u.setFullName("Hoàng Tiến Dũng");
            u.setPhone("0912345678");
            u.setRole(parentRole);
            u.setActive(true);
            return u;
        });
        ph.setPassword(passwordEncoder.encode("123456"));
        ph.setActive(true);
        userRepository.save(ph);

        System.out.println(">>> [DataInitializer] Đã đồng bộ mật khẩu 123456 thành công cho: admin, gv_toan, ph_dung!");
    }
}
