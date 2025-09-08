<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Quản lý Phòng trọ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .sidebar {
            background: linear-gradient(135deg, #dc3545 0%, #6f42c1 100%);
            min-height: 100vh;
            color: white;
        }
        
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            margin: 2px 0;
        }
        
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }
        
        .main-content {
            background: #f8f9fa;
            min-height: 100vh;
        }
        
        .navbar {
            background: white;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .card-header {
            background: linear-gradient(135deg, #dc3545 0%, #6f42c1 100%);
            color: white;
            border-radius: 15px 15px 0 0 !important;
        }
        
        .super-admin-badge {
            background: linear-gradient(135deg, #dc3545 0%, #6f42c1 100%);
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 0.7rem;
            font-weight: bold;
        }
        
        .form-control:focus {
            border-color: #dc3545;
            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #dc3545 0%, #6f42c1 100%);
            border: none;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #c82333 0%, #5a2d91 100%);
            border: none;
        }
        
        .password-strength {
            height: 5px;
            border-radius: 3px;
            margin-top: 5px;
        }
        
        .strength-weak { background-color: #dc3545; }
        .strength-medium { background-color: #ffc107; }
        .strength-strong { background-color: #28a745; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar">
                <div class="p-3">
                    <h4 class="text-center mb-4">
                        <i class="bi bi-shield-fill-exclamation me-2"></i>
                        Super Admin
                    </h4>
                    
                    <div class="text-center mb-4">
                        <div class="bg-light text-dark rounded-circle d-inline-flex align-items-center justify-content-center" 
                             style="width: 60px; height: 60px;">
                            <i class="bi bi-shield-fill-exclamation fs-3"></i>
                        </div>
                        <div class="mt-2">
                            <strong>${user.fullName}</strong>
                            <br>
                            <span class="super-admin-badge">SUPER ADMIN</span>
                        </div>
                    </div>
                    
                    <nav class="nav flex-column">
                        <a class="nav-link" href="${pageContext.request.contextPath}/super-admin/dashboard">
                            <i class="bi bi-speedometer2 me-2"></i>
                            Bảng điều khiển
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/super-admin/admins">
                            <i class="bi bi-person-gear me-2"></i>
                            Quản lý Admin
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/super-admin/audit-logs">
                            <i class="bi bi-journal-text me-2"></i>
                            Nhật ký hoạt động
                        </a>
                        <hr class="text-light">
                        <a class="nav-link text-warning" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right me-2"></i>
                            Đăng xuất
                        </a>
                    </nav>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 main-content">
                <!-- Top Navigation -->
                <nav class="navbar navbar-expand-lg navbar-light">
                    <div class="container-fluid">
                        <h5 class="navbar-brand mb-0">
                            <i class="bi bi-person-${action == 'add' ? 'plus' : 'pencil'} text-primary me-2"></i>
                            ${pageTitle}
                        </h5>
                        <div class="navbar-nav ms-auto">
                            <div class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-shield-fill-exclamation me-1 text-danger"></i>
                                    ${user.fullName}
                                </a>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#">Thông tin cá nhân</a></li>
                                    <li><a class="dropdown-item" href="#">Cài đặt hệ thống</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </nav>
                
                <!-- Content -->
                <div class="p-4">
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb" class="mb-4">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/super-admin/dashboard">Dashboard</a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/super-admin/admins">Quản lý Admin</a>
                            </li>
                            <li class="breadcrumb-item active">${pageTitle}</li>
                        </ol>
                    </nav>
                    
                    <!-- Success/Error Messages -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle me-2"></i>
                            ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <!-- Form Card -->
                    <div class="row justify-content-center">
                        <div class="col-lg-8">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="bi bi-person-${action == 'add' ? 'plus' : 'pencil'} me-2"></i>
                                        ${action == 'add' ? 'Thêm Admin mới' : 'Chỉnh sửa Admin'}
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <form method="post" id="adminForm" novalidate>
                                        <div class="row">
                                            <!-- Left Column -->
                                            <div class="col-md-6">
                                                <!-- Username (only for add) -->
                                                <c:if test="${action == 'add'}">
                                                    <div class="mb-3">
                                                        <label for="username" class="form-label">
                                                            <i class="bi bi-person me-1"></i>
                                                            Tên đăng nhập <span class="text-danger">*</span>
                                                        </label>
                                                        <input type="text" class="form-control" id="username" name="username" 
                                                               value="${admin.username}" required>
                                                        <div class="form-text">Tên đăng nhập phải có ít nhất 3 ký tự</div>
                                                        <div class="invalid-feedback">Vui lòng nhập tên đăng nhập hợp lệ</div>
                                                    </div>
                                                </c:if>
                                                
                                                <!-- Full Name -->
                                                <div class="mb-3">
                                                    <label for="fullName" class="form-label">
                                                        <i class="bi bi-person-badge me-1"></i>
                                                        Họ và tên <span class="text-danger">*</span>
                                                    </label>
                                                    <input type="text" class="form-control" id="fullName" name="fullName" 
                                                           value="${admin.fullName}" required>
                                                    <div class="invalid-feedback">Vui lòng nhập họ và tên</div>
                                                </div>
                                                
                                                <!-- Email -->
                                                <div class="mb-3">
                                                    <label for="email" class="form-label">
                                                        <i class="bi bi-envelope me-1"></i>
                                                        Email <span class="text-danger">*</span>
                                                    </label>
                                                    <input type="email" class="form-control" id="email" name="email" 
                                                           value="${admin.email}" required>
                                                    <div class="invalid-feedback">Vui lòng nhập email hợp lệ</div>
                                                </div>
                                                
                                                <!-- Password (only for add) -->
                                                <c:if test="${action == 'add'}">
                                                    <div class="mb-3">
                                                        <label for="password" class="form-label">
                                                            <i class="bi bi-key me-1"></i>
                                                            Mật khẩu <span class="text-danger">*</span>
                                                        </label>
                                                        <div class="input-group">
                                                            <input type="password" class="form-control" id="password" name="password" required>
                                                            <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                                                <i class="bi bi-eye"></i>
                                                            </button>
                                                        </div>
                                                        <div class="password-strength" id="passwordStrength"></div>
                                                        <div class="form-text">Mật khẩu phải có ít nhất 6 ký tự</div>
                                                        <div class="invalid-feedback">Vui lòng nhập mật khẩu hợp lệ</div>
                                                    </div>
                                                </c:if>
                                            </div>
                                            
                                            <!-- Right Column -->
                                            <div class="col-md-6">
                                                <!-- Phone -->
                                                <div class="mb-3">
                                                    <label for="phone" class="form-label">
                                                        <i class="bi bi-telephone me-1"></i>
                                                        Số điện thoại
                                                    </label>
                                                    <input type="tel" class="form-control" id="phone" name="phone" 
                                                           value="${admin.phone}">
                                                    <div class="form-text">Ví dụ: 0123456789</div>
                                                </div>
                                                
                                                <!-- Address -->
                                                <div class="mb-3">
                                                    <label for="address" class="form-label">
                                                        <i class="bi bi-geo-alt me-1"></i>
                                                        Địa chỉ
                                                    </label>
                                                    <textarea class="form-control" id="address" name="address" rows="3">${admin.address}</textarea>
                                                </div>
                                                
                                                <!-- Admin Info (for edit) -->
                                                <c:if test="${action == 'edit'}">
                                                    <div class="mb-3">
                                                        <label class="form-label">
                                                            <i class="bi bi-info-circle me-1"></i>
                                                            Thông tin tài khoản
                                                        </label>
                                                        <div class="card bg-light">
                                                            <div class="card-body p-3">
                                                                <div class="row">
                                                                    <div class="col-6">
                                                                        <small class="text-muted">Tên đăng nhập:</small>
                                                                        <div><strong>${admin.username}</strong></div>
                                                                    </div>
                                                                    <div class="col-6">
                                                                        <small class="text-muted">Ngày tạo:</small>
                                                                        <div>
                                                                            <fmt:formatDate value="${admin.createdAt}" pattern="dd/MM/yyyy"/>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                        
                                        <!-- Security Notice -->
                                        <div class="alert alert-info">
                                            <i class="bi bi-shield-check me-2"></i>
                                            <strong>Lưu ý bảo mật:</strong>
                                            <ul class="mb-0 mt-2">
                                                <c:if test="${action == 'add'}">
                                                    <li>Mật khẩu sẽ được mã hóa an toàn trước khi lưu trữ</li>
                                                    <li>Hãy thông báo thông tin đăng nhập cho admin sau khi tạo</li>
                                                </c:if>
                                                <li>Admin sẽ có quyền quản lý phòng trọ và người dùng</li>
                                                <li>Bạn có thể tạm khóa hoặc reset mật khẩu admin bất kỳ lúc nào</li>
                                            </ul>
                                        </div>
                                        
                                        <!-- Form Actions -->
                                        <div class="d-flex justify-content-between">
                                            <a href="${pageContext.request.contextPath}/super-admin/admins" class="btn btn-secondary">
                                                <i class="bi bi-arrow-left me-2"></i>
                                                Quay lại
                                            </a>
                                            <div>
                                                <button type="reset" class="btn btn-outline-secondary me-2">
                                                    <i class="bi bi-arrow-clockwise me-2"></i>
                                                    Đặt lại
                                                </button>
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bi bi-${action == 'add' ? 'plus' : 'check'}-circle me-2"></i>
                                                    ${action == 'add' ? 'Tạo Admin' : 'Cập nhật'}
                                                </button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                var forms = document.getElementsByClassName('needs-validation');
                var validation = Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();
        
        // Toggle password visibility
        document.getElementById('togglePassword')?.addEventListener('click', function() {
            const passwordInput = document.getElementById('password');
            const icon = this.querySelector('i');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                icon.className = 'bi bi-eye-slash';
            } else {
                passwordInput.type = 'password';
                icon.className = 'bi bi-eye';
            }
        });
        
        // Password strength indicator
        document.getElementById('password')?.addEventListener('input', function() {
            const password = this.value;
            const strengthBar = document.getElementById('passwordStrength');
            
            let strength = 0;
            if (password.length >= 6) strength++;
            if (password.match(/[a-z]/) && password.match(/[A-Z]/)) strength++;
            if (password.match(/[0-9]/)) strength++;
            if (password.match(/[^a-zA-Z0-9]/)) strength++;
            
            strengthBar.className = 'password-strength';
            if (strength === 0) {
                strengthBar.style.width = '0%';
            } else if (strength <= 2) {
                strengthBar.classList.add('strength-weak');
                strengthBar.style.width = '33%';
            } else if (strength === 3) {
                strengthBar.classList.add('strength-medium');
                strengthBar.style.width = '66%';
            } else {
                strengthBar.classList.add('strength-strong');
                strengthBar.style.width = '100%';
            }
        });
        
        // Username validation
        document.getElementById('username')?.addEventListener('input', function() {
            const username = this.value;
            if (username.length >= 3) {
                this.classList.remove('is-invalid');
                this.classList.add('is-valid');
            } else {
                this.classList.remove('is-valid');
                this.classList.add('is-invalid');
            }
        });
        
        // Email validation
        document.getElementById('email')?.addEventListener('input', function() {
            const email = this.value;
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (emailRegex.test(email)) {
                this.classList.remove('is-invalid');
                this.classList.add('is-valid');
            } else {
                this.classList.remove('is-valid');
                this.classList.add('is-invalid');
            }
        });
        
        // Form submission
        document.getElementById('adminForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Basic validation
            const requiredFields = this.querySelectorAll('[required]');
            let isValid = true;
            
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    field.classList.add('is-invalid');
                    isValid = false;
                } else {
                    field.classList.remove('is-invalid');
                    field.classList.add('is-valid');
                }
            });
            
            if (isValid) {
                this.submit();
            }
        });
    </script>
</body>
</html>