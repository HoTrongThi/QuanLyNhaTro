<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Không tìm thấy trang</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .error-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            backdrop-filter: blur(10px);
            text-align: center;
            max-width: 500px;
        }
        
        .error-icon {
            font-size: 6rem;
            color: #6c757d;
            margin-bottom: 1rem;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            border: none;
            border-radius: 10px;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #495057 0%, #6c757d 100%);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="error-container p-5">
                    <i class="bi bi-exclamation-triangle error-icon"></i>
                    <h1 class="display-4 fw-bold text-secondary mb-3">404</h1>
                    <h2 class="h4 mb-3">Không tìm thấy trang</h2>
                    <p class="text-muted mb-4">
                        Trang bạn đang tìm kiếm không tồn tại hoặc đã bị di chuyển.
                    </p>
                    
                    <div class="d-grid gap-2 d-md-block">
                        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                            <i class="bi bi-house me-2"></i>
                            Về trang chủ
                        </a>
                        <a href="javascript:history.back()" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-2"></i>
                            Quay lại
                        </a>
                    </div>
                    
                    <div class="mt-4">
                        <small class="text-muted">
                            Nếu bạn cho rằng đây là lỗi, vui lòng liên hệ với quản trị viên.
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
