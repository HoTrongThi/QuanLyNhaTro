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
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .error-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 3rem;
            text-align: center;
            max-width: 600px;
            width: 90%;
        }
        
        .error-icon {
            font-size: 8rem;
            color: #dc3545;
            margin-bottom: 2rem;
        }
        
        .error-code {
            font-size: 4rem;
            font-weight: bold;
            color: #dc3545;
            margin-bottom: 1rem;
        }
        
        .error-title {
            font-size: 2rem;
            color: #333;
            margin-bottom: 1rem;
        }
        
        .error-description {
            color: #666;
            font-size: 1.1rem;
            margin-bottom: 2rem;
            line-height: 1.6;
        }
        
        .btn-home {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            color: white;
        }
        
        .user-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 2rem;
        }
        
        .role-badge {
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: bold;
        }
        
        .role-super-admin {
            background: #dc3545;
            color: white;
        }
        
        .role-admin {
            background: #007bff;
            color: white;
        }
        
        .role-user {
            background: #28a745;
            color: white;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">
            <i class="bi bi-shield-exclamation"></i>
        </div>
        
        <div class="error-code">403</div>
        
        <h1 class="error-title">Truy cập bị từ chối</h1>
        
        <c:if test="${not empty user}">
            <div class="user-info">
                <div class="mb-2">
                    <strong>Người dùng hiện tại:</strong> ${user.fullName}
                </div>
                <div>
                    <strong>Vai trò:</strong> 
                    <span class="role-badge role-${user.role.toLowerCase().replace('_', '-')}">
                        <i class="${user.roleIcon} me-1"></i>
                        ${user.roleDisplayName}
                    </span>
                </div>
            </div>
        </c:if>
        
        <div class="error-description">
            <p><strong>Bạn không có quyền truy cập vào trang này.</strong></p>
            <p>Trang bạn đang cố gắng truy cập yêu cầu quyền hạn cao hơn vai trò hiện tại của bạn.</p>
            
            <c:choose>
                <c:when test="${empty user}">
                    <p>Vui lòng đăng nhập để tiếp tục.</p>
                </c:when>
                <c:when test="${user.role == 'USER'}">
                    <p>Trang này chỉ dành cho quản trị viên. Nếu bạn cần truy cập, vui lòng liên hệ với admin.</p>
                </c:when>
                <c:when test="${user.role == 'ADMIN'}">
                    <p>Trang này chỉ dành cho Super Admin. Nếu bạn cần quyền truy cập, vui lòng liên hệ với Super Admin.</p>
                </c:when>
                <c:otherwise>
                    <p>Có lỗi xảy ra trong việc xác thực quyền truy cập.</p>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="d-flex justify-content-center gap-3 flex-wrap">
            <c:choose>
                <c:when test="${empty user}">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-home">
                        <i class="bi bi-box-arrow-in-right me-2"></i>
                        Đăng nhập
                    </a>
                </c:when>
                <c:when test="${user.role == 'SUPER_ADMIN'}">
                    <a href="${pageContext.request.contextPath}/super-admin/dashboard" class="btn btn-home">
                        <i class="bi bi-house me-2"></i>
                        Về Dashboard Super Admin
                    </a>
                </c:when>
                <c:when test="${user.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-home">
                        <i class="bi bi-house me-2"></i>
                        Về Dashboard Admin
                    </a>
                </c:when>
                <c:when test="${user.role == 'USER'}">
                    <a href="${pageContext.request.contextPath}/user/dashboard" class="btn btn-home">
                        <i class="bi bi-house me-2"></i>
                        Về Dashboard
                    </a>
                </c:when>
            </c:choose>
            
            <c:if test="${not empty user}">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-secondary">
                    <i class="bi bi-box-arrow-right me-2"></i>
                    Đăng xuất
                </a>
            </c:if>
        </div>
        
        <hr class="my-4">
        
        <div class="text-muted">
            <small>
                <i class="bi bi-info-circle me-1"></i>
                Nếu bạn cho rằng đây là lỗi, vui lòng liên hệ với quản trị viên hệ thống.
            </small>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto redirect after 10 seconds if not logged in
        <c:if test="${empty user}">
            setTimeout(function() {
                window.location.href = '${pageContext.request.contextPath}/login';
            }, 10000);
        </c:if>
        
        // Add some animation
        document.addEventListener('DOMContentLoaded', function() {
            const container = document.querySelector('.error-container');
            container.style.opacity = '0';
            container.style.transform = 'translateY(20px)';
            
            setTimeout(function() {
                container.style.transition = 'all 0.5s ease';
                container.style.opacity = '1';
                container.style.transform = 'translateY(0)';
            }, 100);
        });
    </script>
</body>
</html>