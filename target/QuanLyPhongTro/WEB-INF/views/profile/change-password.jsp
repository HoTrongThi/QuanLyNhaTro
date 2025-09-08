<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Quản lý Phòng trọ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .password-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }
        
        .card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }
        
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px 20px 0 0 !important;
            padding: 2rem;
        }
        
        .card-body {
            padding: 2rem;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 0.75rem 2rem;
            font-weight: 600;
        }
        
        .btn-outline-secondary {
            border: 2px solid #6c757d;
            color: #6c757d;
            border-radius: 10px;
            padding: 0.75rem 2rem;
            font-weight: 600;
        }
        
        .navbar {
            background: rgba(255, 255, 255, 0.95) !important;
            backdrop-filter: blur(10px);
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
        }
        
        .navbar-brand {
            font-weight: 700;
            color: #667eea !important;
        }
        
        .breadcrumb {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 10px;
            padding: 15px 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }
        
        .security-tips {
            background: rgba(23, 162, 184, 0.1);
            border: 1px solid #17a2b8;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .password-strength {
            height: 5px;
            border-radius: 3px;
            margin-top: 0.5rem;
            transition: all 0.3s;
        }
        
        .strength-weak { background-color: #dc3545; width: 33%; }
        .strength-medium { background-color: #fd7e14; width: 66%; }
        .strength-strong { background-color: #28a745; width: 100%; }
        
        .requirements-list {
            font-size: 0.9rem;
            margin-top: 1rem;
        }
        
        .requirement {
            color: #6c757d;
            transition: color 0.3s;
        }
        
        .requirement.met {
            color: #28a745;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg fixed-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="bi bi-building me-2"></i>
                Quản lý Phòng trọ
            </a>
            
            <div class="navbar-nav ms-auto">
                <div class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="bi bi-person-circle me-1"></i>
                        ${user.fullName}
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile">
                            <i class="bi bi-person me-2"></i>Thông tin cá nhân
                        </a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile/edit">
                            <i class="bi bi-pencil me-2"></i>Chỉnh sửa thông tin
                        </a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                        </a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <div class="password-container">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mt-5 mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/user/profile">
                        <i class="bi bi-person me-1"></i>Thông tin cá nhân
                    </a>
                </li>
                <li class="breadcrumb-item active">Đổi mật khẩu</li>
            </ol>
        </nav>

        <!-- Error/Success Messages -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Security Tips -->
        <div class="security-tips">
            <h6 class="text-info mb-3">
                <i class="bi bi-shield-check me-2"></i>
                Mẹo bảo mật
            </h6>
            <ul class="mb-0">
                <li>Sử dụng mật khẩu có ít nhất 8 ký tự</li>
                <li>Kết hợp chữ hoa, chữ thường, số và ký tự đặc biệt</li>
                <li>Không sử dụng thông tin cá nhân dễ đoán</li>
                <li>Đổi mật khẩu định kỳ để tăng cường bảo mật</li>
            </ul>
        </div>

        <!-- Change Password Form -->
        <div class="card">
            <div class="card-header text-center">
                <h4 class="mb-0">
                    <i class="bi bi-key me-2"></i>
                    Đổi mật khẩu
                </h4>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/user/profile/change-password" method="post" id="passwordForm">
                    <div class="mb-4">
                        <label for="currentPassword" class="form-label">
                            <i class="bi bi-lock me-1"></i>
                            Mật khẩu hiện tại <span class="text-danger">*</span>
                        </label>
                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                    </div>

                    <div class="mb-4">
                        <label for="newPassword" class="form-label">
                            <i class="bi bi-key me-1"></i>
                            Mật khẩu mới <span class="text-danger">*</span>
                        </label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" 
                               required minlength="6" onkeyup="checkPasswordStrength()">
                        <div class="password-strength" id="strengthBar"></div>
                        <div class="requirements-list">
                            <div class="requirement" id="lengthReq">
                                <i class="bi bi-circle me-1"></i>Ít nhất 6 ký tự
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="confirmPassword" class="form-label">
                            <i class="bi bi-check-square me-1"></i>
                            Xác nhận mật khẩu mới <span class="text-danger">*</span>
                        </label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                               required onkeyup="checkPasswordMatch()">
                        <div class="invalid-feedback" id="passwordMatch"></div>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-outline-secondary me-md-2">
                            <i class="bi bi-arrow-left me-1"></i>
                            Hủy bỏ
                        </a>
                        <button type="submit" class="btn btn-primary" id="submitBtn" disabled>
                            <i class="bi bi-check-lg me-1"></i>
                            Đổi mật khẩu
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function checkPasswordStrength() {
            const password = document.getElementById('newPassword').value;
            const strengthBar = document.getElementById('strengthBar');
            const lengthReq = document.getElementById('lengthReq');
            
            // Check length requirement
            if (password.length >= 6) {
                lengthReq.classList.add('met');
                lengthReq.innerHTML = '<i class="bi bi-check-circle-fill me-1"></i>Ít nhất 6 ký tự';
            } else {
                lengthReq.classList.remove('met');
                lengthReq.innerHTML = '<i class="bi bi-circle me-1"></i>Ít nhất 6 ký tự';
            }
            
            // Calculate strength
            let strength = 0;
            if (password.length >= 6) strength += 1;
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength += 1;
            if (/[0-9]/.test(password)) strength += 1;
            if (/[^A-Za-z0-9]/.test(password)) strength += 1;
            
            // Update strength bar
            strengthBar.className = 'password-strength';
            if (strength >= 4) {
                strengthBar.classList.add('strength-strong');
            } else if (strength >= 2) {
                strengthBar.classList.add('strength-medium');
            } else if (strength >= 1) {
                strengthBar.classList.add('strength-weak');
            }
            
            checkFormValidity();
        }
        
        function checkPasswordMatch() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const matchDiv = document.getElementById('passwordMatch');
            const confirmInput = document.getElementById('confirmPassword');
            
            if (confirmPassword.length > 0) {
                if (newPassword === confirmPassword) {
                    confirmInput.classList.remove('is-invalid');
                    confirmInput.classList.add('is-valid');
                    matchDiv.innerHTML = '';
                } else {
                    confirmInput.classList.remove('is-valid');
                    confirmInput.classList.add('is-invalid');
                    matchDiv.innerHTML = 'Mật khẩu xác nhận không khớp';
                }
            } else {
                confirmInput.classList.remove('is-valid', 'is-invalid');
                matchDiv.innerHTML = '';
            }
            
            checkFormValidity();
        }
        
        function checkFormValidity() {
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const submitBtn = document.getElementById('submitBtn');
            
            const isValid = currentPassword.length > 0 && 
                           newPassword.length >= 6 && 
                           newPassword === confirmPassword &&
                           currentPassword !== newPassword;
            
            submitBtn.disabled = !isValid;
        }
        
        // Add event listeners
        document.getElementById('currentPassword').addEventListener('input', checkFormValidity);
        document.getElementById('confirmPassword').addEventListener('input', checkPasswordMatch);
    </script>
</body>
</html>
