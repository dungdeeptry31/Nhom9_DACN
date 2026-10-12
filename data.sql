-- =======================================================
-- HỆ THỐNG QUẢN LÝ TRUNG TÂM HỌC THÊM EDUCENTER
-- FILE: data.sql (DỮ LIỆU MẪU ĐỂ TEST HỆ THỐNG)
-- Mật khẩu mặc định cho TẤT CẢ tài khoản là: 123456
-- Chuỗi mã hóa BCrypt của 123456:
-- $2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG
-- =======================================================

USE `educenter_db`;

-- 1. BẢNG roles
INSERT INTO `roles` (`id`, `name`, `description`) VALUES
(1, 'ROLE_ADMIN', 'Quản trị viên / Nhân viên trung tâm'),
(2, 'ROLE_TEACHER', 'Giáo viên phụ trách giảng dạy'),
(3, 'ROLE_PARENT', 'Phụ huynh học sinh');

-- 2. BẢNG users (Tài khoản)
-- Password mặc định: 123456
INSERT INTO `users` (`id`, `username`, `password`, `email`, `full_name`, `phone`, `address`, `role_id`, `active`) VALUES
(1, 'admin', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'admin@educenter.edu.vn', 'Quản Trị Viên EduCenter', '0988000001', 'Hà Nội', 1, 1),
(2, 'gv_toan', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'tranvantoan@educenter.edu.vn', 'ThS. Trần Văn Toán', '0988000002', 'Cầu Giấy, Hà Nội', 2, 1),
(3, 'gv_ly', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'lethily@educenter.edu.vn', 'Cô Lê Thị Lý', '0988000003', 'Bắc Từ Liêm, Hà Nội', 2, 1),
(4, 'gv_hoa', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'phamvanhoa@educenter.edu.vn', 'ThS. Phạm Văn Hóa', '0988000004', 'Nam Từ Liêm, Hà Nội', 2, 1),
(5, 'ph_dung', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'hoangtiendung@gmail.com', 'Hoàng Tiến Dũng', '0912345678', 'Nhổn, Bắc Từ Liêm, Hà Nội', 3, 1),
(6, 'ph_lan', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'nguyenthilan@gmail.com', 'Nguyễn Thị Lan', '0912345679', 'Hồ Tùng Mậu, Cầu Giấy, Hà Nội', 3, 1),
(7, 'ph_minh', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'vuquangminh@gmail.com', 'Vũ Quang Minh', '0912345680', 'Xuân Thủy, Cầu Giấy, Hà Nội', 3, 1);

-- 3. BẢNG parents (Hồ sơ phụ huynh)
INSERT INTO `parents` (`id`, `user_id`, `occupation`, `note`) VALUES
(1, 5, 'Kỹ sư CNTT', 'Phụ huynh em Hoàng Nam và Hoàng Mai'),
(2, 6, 'Kế toán trưởng', 'Phụ huynh em Lê Quốc Bảo'),
(3, 7, 'Giám đốc doanh nghiệp', 'Phụ huynh em Vũ Tuấn Kiệt');

-- 4. BẢNG teachers (Hồ sơ giáo viên)
INSERT INTO `teachers` (`id`, `user_id`, `specialization`, `degree`, `experience`) VALUES
(1, 2, 'Toán THPT & Luyện thi ĐH', 'Thạc sĩ Toán học - ĐH Sư Phạm Hà Nội', '10 năm kinh nghiệm luyện thi vào 10 và THPT Quốc gia'),
(2, 3, 'Vật Lý THPT', 'Cử nhân Sư phạm Vật Lý - ĐH Sư Phạm Hà Nội', '6 năm kinh nghiệm giảng dạy Vật Lý'),
(3, 4, 'Hóa Học THPT & Chuyên sâu', 'Thạc sĩ Hóa học - ĐH Khoa học Tự nhiên', '8 năm kinh nghiệm bồi dưỡng học sinh giỏi Hóa');

-- 5. BẢNG students (Học sinh)
INSERT INTO `students` (`id`, `full_name`, `date_of_birth`, `gender`, `phone`, `school`, `grade_level`, `parent_id`, `active`) VALUES
(1, 'Hoàng Nam', '2009-03-15', 'Nam', '0961000001', 'THPT Chuyên Sư Phạm', 'Lớp 10', 1, 1),
(2, 'Hoàng Mai', '2011-08-20', 'Nữ', '0961000002', 'THCS Cầu Giấy', 'Lớp 8', 1, 1),
(3, 'Lê Quốc Bảo', '2009-05-10', 'Nam', '0961000003', 'THPT Yên Hòa', 'Lớp 10', 2, 1),
(4, 'Vũ Tuấn Kiệt', '2009-11-25', 'Nam', '0961000004', 'THPT Cầu Giấy', 'Lớp 10', 3, 1),
(5, 'Trần Thảo Nhi', '2010-02-14', 'Nữ', '0961000005', 'THCS Nghĩa Tân', 'Lớp 9', 2, 1);

-- 6. BẢNG subjects (Môn học)
INSERT INTO `subjects` (`id`, `name`, `description`, `active`) VALUES
(1, 'Toán học', 'Môn Toán nền tảng và nâng cao từ lớp 6 đến lớp 12', 1),
(2, 'Vật lý', 'Môn Vật lý lý thuyết và thực hành, luyện thi chuyển cấp', 1),
(3, 'Hóa học', 'Môn Hóa học cơ bản và bồi dưỡng chuyên đề', 1);

-- 7. BẢNG rooms (Phòng học)
INSERT INTO `rooms` (`id`, `name`, `capacity`, `location`, `description`, `active`) VALUES
(1, 'Phòng P101', 30, 'Tầng 1 - Dãy A', 'Phòng học máy chiếu, điều hòa 2 chiều', 1),
(2, 'Phòng P102', 25, 'Tầng 1 - Dãy A', 'Phòng tiêu chuẩn, điều hòa, bảng từ', 1),
(3, 'Phòng P201', 35, 'Tầng 2 - Dãy B', 'Phòng lớn phục vụ lớp nâng cao và thi thử', 1);

-- 8. BẢNG classes (Lớp học)
INSERT INTO `classes` (`id`, `name`, `subject_id`, `teacher_id`, `max_students`, `tuition_fee`, `status`, `start_date`, `end_date`, `description`) VALUES
(1, 'Toán 10 - Nâng Cao (T10-NC1)', 1, 1, 25, 1200000.00, 'ACTIVE', '2026-09-01', '2027-05-30', 'Lớp bồi dưỡng Toán nâng cao khối 10 ôn thi ĐH'),
(2, 'Vật Lý 10 - Cơ Bản & Ôn Luyện (L10-CB1)', 2, 2, 25, 1000000.00, 'ACTIVE', '2026-09-01', '2027-05-30', 'Lớp củng cố kiến thức Vật lý 10 bám sát SGK mới'),
(3, 'Hóa Học 10 - Nâng Cao (H10-NC1)', 3, 3, 20, 1100000.00, 'ACTIVE', '2026-09-01', '2027-05-30', 'Lớp Hóa học 10 chuyên đề bài tập và thực hành');

-- 9. BẢNG class_students (Phân lớp học sinh)
INSERT INTO `class_students` (`id`, `class_id`, `student_id`, `enrolled_date`, `status`) VALUES
(1, 1, 1, '2026-09-01', 'ACTIVE'), -- Hoàng Nam học Toán 10
(2, 1, 3, '2026-09-01', 'ACTIVE'), -- Lê Quốc Bảo học Toán 10
(3, 1, 4, '2026-09-01', 'ACTIVE'), -- Vũ Tuấn Kiệt học Toán 10
(4, 2, 1, '2026-09-01', 'ACTIVE'), -- Hoàng Nam học Lý 10
(5, 2, 3, '2026-09-01', 'ACTIVE'), -- Lê Quốc Bảo học Lý 10
(6, 3, 4, '2026-09-01', 'ACTIVE'); -- Vũ Tuấn Kiệt học Hóa 10

-- 10. BẢNG schedules (Thời khóa biểu - Đảm bảo không trùng lịch)
INSERT INTO `schedules` (`id`, `class_id`, `room_id`, `day_of_week`, `start_time`, `end_time`, `active`) VALUES
-- Lớp 1 (Toán 10 - Thầy Toán - P101): Thứ 2 & Thứ 5 (17:30 - 19:30)
(1, 1, 1, 2, '17:30:00', '19:30:00', 1),
(2, 1, 1, 5, '17:30:00', '19:30:00', 1),
-- Lớp 2 (Lý 10 - Cô Lý - P102): Thứ 3 & Thứ 6 (18:00 - 20:00)
(3, 2, 2, 3, '18:00:00', '20:00:00', 1),
(4, 2, 2, 6, '18:00:00', '20:00:00', 1),
-- Lớp 3 (Hóa 10 - Thầy Hóa - P201): Thứ 4 & Thứ 7 (18:00 - 20:00)
(5, 3, 3, 4, '18:00:00', '20:00:00', 1),
(6, 3, 3, 7, '18:00:00', '20:00:00', 1);

-- 11. BẢNG registrations (Đơn đăng ký học)
INSERT INTO `registrations` (`id`, `parent_id`, `student_id`, `class_id`, `registration_date`, `status`, `note`, `admin_note`, `processed_by`, `processed_date`) VALUES
(1, 1, 1, 1, '2026-08-25 09:00:00', 'APPROVED', 'Đăng ký cho cháu Nam học Toán nâng cao', 'Đã duyệt và xếp vào lớp T10-NC1', 1, '2026-08-26 10:00:00'),
(2, 2, 3, 2, '2026-08-26 14:00:00', 'APPROVED', 'Đăng ký cho cháu Bảo học Lý 10', 'Đã duyệt', 1, '2026-08-27 08:30:00'),
(3, 1, 2, 1, '2026-10-01 15:30:00', 'PENDING', 'Xin đăng ký học thử môn Toán', NULL, NULL, NULL);

-- 12. BẢNG attendance (Điểm danh mẫu)
INSERT INTO `attendance` (`id`, `class_id`, `student_id`, `attendance_date`, `status`, `note`, `created_by`) VALUES
(1, 1, 1, '2026-10-05', 'PRESENT', 'Đúng giờ, hăng hái phát biểu', 2),
(2, 1, 3, '2026-10-05', 'PRESENT', 'Đúng giờ', 2),
(3, 1, 4, '2026-10-05', 'EXCUSED', 'Nghỉ có phép do bị ốm', 2),
(4, 1, 1, '2026-10-08', 'PRESENT', 'Đúng giờ', 2),
(5, 1, 3, '2026-10-08', 'ABSENT', 'Nghỉ không phép', 2),
(6, 1, 4, '2026-10-08', 'PRESENT', 'Đúng giờ', 2);

-- 13. BẢNG grades (Bảng điểm mẫu)
INSERT INTO `grades` (`id`, `class_id`, `student_id`, `test_score`, `midterm_score`, `final_score`, `average_score`, `note`) VALUES
(1, 1, 1, 9.00, 8.50, 9.00, 8.83, 'Học lực Xuất sắc, tư duy logic rất tốt'),
(2, 1, 3, 7.50, 7.00, 8.00, 7.58, 'Khá, cần rèn luyện thêm bài tập hình học'),
(3, 1, 4, 8.00, 8.00, 7.50, 7.75, 'Khá, chăm chỉ làm bài');

-- 14. BẢNG tuition (Khoản học phí)
INSERT INTO `tuition` (`id`, `student_id`, `class_id`, `amount`, `due_date`, `status`, `description`) VALUES
(1, 1, 1, 1200000.00, '2026-10-15', 'PAID', 'Học phí Tháng 10/2026 - Lớp Toán 10 NC'),
(2, 3, 1, 1200000.00, '2026-10-15', 'UNPAID', 'Học phí Tháng 10/2026 - Lớp Toán 10 NC'),
(3, 4, 1, 1200000.00, '2026-10-15', 'UNPAID', 'Học phí Tháng 10/2026 - Lớp Toán 10 NC'),
(4, 1, 2, 1000000.00, '2026-10-15', 'PAID', 'Học phí Tháng 10/2026 - Lớp Lý 10 CB');

-- 15. BẢNG payments (Lịch sử thanh toán mẫu)
INSERT INTO `payments` (`id`, `tuition_id`, `amount`, `payment_date`, `payment_method`, `transaction_code`, `status`, `vnpay_response_code`, `note`) VALUES
(1, 1, 1200000.00, '2026-10-06 14:25:30', 'VNPAY', 'VNP14892011', 'SUCCESS', '00', 'Thanh toán học phí Toán 10 qua VNPay thành công'),
(2, 4, 1000000.00, '2026-10-07 09:12:15', 'VNPAY', 'VNP14893542', 'SUCCESS', '00', 'Thanh toán học phí Lý 10 qua VNPay thành công');
