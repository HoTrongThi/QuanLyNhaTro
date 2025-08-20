<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Quản lý Phòng trọ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .sidebar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0 !important;
        }
        
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
        }

        .chart-container {
            position: relative;
            height: 400px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar">
                <div class="p-3">
                    <h4 class="text-center mb-4">
                        <i class="bi bi-building me-2"></i>
                        Admin Panel
                    </h4>
                    
                    <div class="text-center mb-4">
                        <div class="bg-light text-dark rounded-circle d-inline-flex align-items-center justify-content-center" 
                             style="width: 60px; height: 60px;">
                            <i class="bi bi-person-gear fs-3"></i>
                        </div>
                        <div class="mt-2">
                            <strong>${user.fullName}</strong>
                            <br>
                            <small class="text-light">Quản trị viên</small>
                        </div>
                    </div>
                    
                    <nav class="nav flex-column">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="bi bi-speedometer2 me-2"></i>
                            Bảng điều khiển
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                            <i class="bi bi-people me-2"></i>
                            Quản lý Người dùng
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/rooms">
                            <i class="bi bi-door-open me-2"></i>
                            Quản lý Phòng trọ
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/services">
                            <i class="bi bi-tools me-2"></i>
                            Quản lý Dịch vụ
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/tenants">
                            <i class="bi bi-person-check me-2"></i>
                            Quản lý Thuê trọ
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/additional-costs">
                            <i class="bi bi-receipt-cutoff me-2"></i>
                            Chi phí phát sinh
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/bills">
                            <i class="bi bi-receipt me-2"></i>
                            Quản lý Hóa đơn
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/messages">
                            <i class="bi bi-chat-dots me-2"></i>
                            Tin nhắn
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/reports">
                            <i class="bi bi-graph-up me-2"></i>
                            Báo cáo & Thống kê
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
                        <h5 class="navbar-brand mb-0">${pageTitle}</h5>
                        <div class="navbar-nav ms-auto">
                            <div class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-person-circle me-1"></i>
                                    ${user.fullName}
                                </a>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#">Thông tin cá nhân</a></li>
                                    <li><a class="dropdown-item" href="#">Cài đặt</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </nav>
                
                <!-- Dashboard Content -->
                <div class="p-4">
                    <!-- Statistics Cards -->
                    <div class="row mb-4">
                        <div class="col-md-3 mb-3">
                            <div class="card stats-card">
                                <div class="card-body text-center">
                                    <i class="bi bi-door-open fs-1 mb-2"></i>
                                    <h3>${totalRooms}</h3>
                                    <p class="mb-0">Tổng Phòng trọ</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card bg-success text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-check-circle fs-1 mb-2"></i>
                                    <h3>${totalRooms - occupiedRooms}</h3>
                                    <p class="mb-0">Phòng Có sẵn</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card bg-warning text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-person-check fs-1 mb-2"></i>
                                    <h3>${occupiedRooms}</h3>
                                    <p class="mb-0">Phòng Đã thuê</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card bg-info text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-receipt fs-1 mb-2"></i>
                                    <h3><fmt:formatNumber value="${currentMonthRevenue / 1000000}" maxFractionDigits="1"/>M</h3>
                                    <p class="mb-0">Hóa đơn tháng này</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Charts Section -->
                    <div class="row mb-4">
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="bi bi-graph-up me-2"></i>
                                        Doanh Thu 12 Tháng Qua
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="chart-container">
                                        <canvas id="revenueChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="bi bi-pie-chart me-2"></i>
                                        Tỷ Lệ Lấp Đầy
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="chart-container" style="height: 300px;">
                                        <canvas id="occupancyChart"></canvas>
                                    </div>
                                    <div class="text-center mt-3">
                                        <h4 class="text-primary">${occupancyRate}%</h4>
                                        <p class="mb-0">Tỷ lệ lấp đầy hiện tại</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Additional Info -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="bi bi-currency-dollar me-2"></i>
                                        Thông Tin Tài Chính
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="text-center">
                                                <h4 class="text-success">
                                                    <fmt:formatNumber value="${totalRevenue / 1000000}" maxFractionDigits="1"/>M₫
                                                </h4>
                                                <p class="mb-0">Tổng Doanh Thu</p>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="text-center">
                                                <h4 class="text-primary">
                                                    <fmt:formatNumber value="${currentMonthRevenue / 1000000}" maxFractionDigits="1"/>M₫
                                                </h4>
                                                <p class="mb-0">Doanh Thu Tháng Này</p>
                                            </div>
                                        </div>
                                    </div>
                                    <hr>
                                    <div class="d-flex justify-content-between">
                                        <span>Hóa đơn đã thanh toán:</span>
                                        <span class="text-success">${paidInvoices}</span>
                                    </div>
                                    <div class="d-flex justify-content-between">
                                        <span>Hóa đơn chưa thanh toán:</span>
                                        <span class="text-warning">${unpaidInvoices}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="bi bi-activity me-2"></i>
                                        Hoạt Động Gần Đây
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${not empty recentInvoices}">
                                            <c:forEach var="invoice" items="${recentInvoices}" end="4">
                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                    <div>
                                                        <strong>${invoice.tenantName}</strong>
                                                        <br>
                                                        <small class="text-muted">${invoice.roomName}</small>
                                                    </div>
                                                    <div class="text-end">
                                                        <span class="text-primary">
                                                            <fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="" pattern="#,##0"/>₫
                                                        </span>
                                                        <br>
                                                        <c:choose>
                                                            <c:when test="${invoice.status == 'PAID'}">
                                                                <span class="badge bg-success">Đã thanh toán</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-warning">Chưa thanh toán</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                                <c:if test="${!status.last}"><hr></c:if>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted text-center">Chưa có hoạt động gần đây</p>
                                        </c:otherwise>
                                    </c:choose>
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
        // Revenue Chart
        const ctx = document.getElementById('revenueChart').getContext('2d');
        
        const monthLabels = [
            <c:forEach var="label" items="${monthLabels}" varStatus="status">
                "${label}"<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        
        const revenueData = [
            <c:forEach var="revenue" items="${monthlyRevenues}" varStatus="status">
                ${revenue}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: monthLabels,
                datasets: [{
                    label: 'Doanh Thu (₫)',
                    data: revenueData,
                    borderColor: '#667eea',
                    backgroundColor: 'rgba(102, 126, 234, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN').format(value) + '₫';
                            }
                        }
                    }
                },
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return 'Doanh thu: ' + new Intl.NumberFormat('vi-VN').format(context.parsed.y) + '₫';
                            }
                        }
                    }
                }
            }
        });

        // Occupancy Chart
        const occupancyCtx = document.getElementById('occupancyChart').getContext('2d');
        
        new Chart(occupancyCtx, {
            type: 'doughnut',
            data: {
                labels: ['Phòng đã thuê', 'Phòng trống'],
                datasets: [{
                    data: [${occupiedRooms}, ${totalRooms - occupiedRooms}],
                    backgroundColor: ['#dc3545', '#28a745'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    </script>
</body>
</html>
