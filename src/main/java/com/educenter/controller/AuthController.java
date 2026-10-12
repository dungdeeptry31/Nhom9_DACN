package com.educenter.controller;

import com.educenter.dto.RegisterDTO;
import com.educenter.entity.Parent;
import com.educenter.entity.Role;
import com.educenter.entity.User;
import com.educenter.repository.ParentRepository;
import com.educenter.repository.RoleRepository;
import com.educenter.repository.UserRepository;
import jakarta.validation.Valid;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class AuthController {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final ParentRepository parentRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthController(UserRepository userRepository,
                          RoleRepository roleRepository,
                          ParentRepository parentRepository,
                          PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.parentRepository = parentRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping("/")
    public String home(Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated()) {
            for (GrantedAuthority authority : authentication.getAuthorities()) {
                String role = authority.getAuthority();
                if ("ROLE_ADMIN".equals(role)) return "redirect:/admin/dashboard";
                if ("ROLE_TEACHER".equals(role)) return "redirect:/teacher/dashboard";
                if ("ROLE_PARENT".equals(role)) return "redirect:/parent/dashboard";
            }
        }
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String login(Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated()) {
            return "redirect:/";
        }
        return "auth/login";
    }

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("registerDTO", new RegisterDTO());
        return "auth/register";
    }

    @PostMapping("/register")
    public String processRegister(@Valid @ModelAttribute("registerDTO") RegisterDTO dto,
                                  BindingResult result,
                                  Model model) {
        if (!dto.getPassword().equals(dto.getConfirmPassword())) {
            result.rejectValue("confirmPassword", "error.registerDTO", "Mật khẩu xác nhận không khớp");
        }

        if (userRepository.existsByUsername(dto.getUsername())) {
            result.rejectValue("username", "error.registerDTO", "Tên đăng nhập đã được sử dụng");
        }

        if (userRepository.existsByEmail(dto.getEmail())) {
            result.rejectValue("email", "error.registerDTO", "Email đã được đăng ký trong hệ thống");
        }

        if (result.hasErrors()) {
            return "auth/register";
        }

        Role parentRole = roleRepository.findByName("ROLE_PARENT")
                .orElseThrow(() -> new RuntimeException("Chưa cấu hình role ROLE_PARENT trong database"));

        User user = new User();
        user.setUsername(dto.getUsername());
        user.setPassword(passwordEncoder.encode(dto.getPassword()));
        user.setEmail(dto.getEmail());
        user.setFullName(dto.getFullName());
        user.setPhone(dto.getPhone());
        user.setAddress(dto.getAddress());
        user.setRole(parentRole);
        user.setActive(true);
        User savedUser = userRepository.save(user);

        Parent parent = new Parent();
        parent.setUser(savedUser);
        parent.setOccupation(dto.getOccupation());
        parentRepository.save(parent);

        return "redirect:/login?registered=true";
    }

    @GetMapping("/403")
    public String accessDenied() {
        return "error/403";
    }
}
