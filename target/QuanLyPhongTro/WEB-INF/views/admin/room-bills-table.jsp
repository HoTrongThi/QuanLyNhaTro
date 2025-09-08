<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:choose>
    <c:when test="${not empty error}">
        <div class="text-center p-4">
            <div class="text-danger">
                <i class="bi bi-exclamation-triangle fs-1 mb-3"></i>
                <h5>${error}</h5>
            </div>
        </div>
    </c:when>
    <c:when test="${not empty invoices}">
        <div class="table-responsive">
            <table class="table table-hover bills-table mb-0">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Kỳ thanh toán</th>
                        <th>Khách thuê</th>
                        <th>Tiền phòng</th>
                        <th>Tiền dịch vụ</th>
                        <th>Chi phí PS</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="invoice" items="${invoices}">
                        <tr>
                            <td><strong>#${invoice.invoiceId}</strong></td>
                            <td><strong>${invoice.formattedPeriod}</strong></td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-person fs-6 text-secondary me-1"></i>
                                    <div>
                                        <div class="small">${invoice.tenantName}</div>
                                        <small class="text-muted">Đại diện phòng</small>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <fmt:formatNumber value="${invoice.roomPrice}" 
                                                type="currency" 
                                                currencySymbol="₫" 
                                                groupingUsed="true"/>
                            </td>
                            <td>
                                <fmt:formatNumber value="${invoice.serviceTotal}" 
                                                type="currency" 
                                                currencySymbol="₫" 
                                                groupingUsed="true"/>
                            </td>
                            <td>
                                <fmt:formatNumber value="${invoice.additionalTotal}" 
                                                type="currency" 
                                                currencySymbol="₫" 
                                                groupingUsed="true"/>
                            </td>
                            <td>
                                <strong>
                                    <fmt:formatNumber value="${invoice.totalAmount}" 
                                                    type="currency" 
                                                    currencySymbol="₫" 
                                                    groupingUsed="true"/>
                                </strong>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${invoice.status == 'PAID'}">
                                        <span class="badge bg-success">
                                            <i class="bi bi-check-circle me-1"></i>
                                            Đã thanh toán
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger">
                                            <i class="bi bi-exclamation-triangle me-1"></i>
                                            Chưa thanh toán
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy"/>
                                <br>
                                <small class="text-muted">
                                    <fmt:formatDate value="${invoice.createdAt}" pattern="HH:mm"/>
                                </small>
                            </td>
                            <td class="text-center">
                                <div class="btn-group btn-group-sm" role="group">
                                        <button type="button" 
                                                class="btn btn-info btn-sm" 
                                                onclick="showBillDetail(${invoice.invoiceId})" 
                                                title="Xem chi tiết">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    <c:if test="${invoice.status == 'UNPAID'}">
                                        <button type="button" 
                                                class="btn btn-outline-success" 
                                                onclick="markAsPaid(${invoice.invoiceId})" 
                                                title="Đánh dấu đã thanh toán">
                                            <i class="bi bi-check"></i>
                                        </button>
                                    </c:if>
                                    <button type="button" 
                                            class="btn btn-outline-danger" 
                                            onclick="confirmDelete(${invoice.invoiceId})" 
                                            title="Xóa">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        
        <!-- Summary Info -->
        <div class="p-3 bg-light border-top">
            <div class="row">
                <div class="col-md-6">
                    <h6 class="text-muted mb-2">
                        <i class="bi bi-people me-1"></i>
                        Khách thuê hiện tại:
                    </h6>
                    <c:choose>
                        <c:when test="${not empty activeTenants}">
                            <c:forEach var="tenant" items="${activeTenants}" varStatus="status">
                                <span class="badge bg-primary me-1 mb-1">${tenant.fullName}</span>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <span class="text-muted">Không có khách thuê</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="col-md-6">
                    <h6 class="text-muted mb-2">
                        <i class="bi bi-receipt me-1"></i>
                        Thống kê hóa đơn chưa thanh toán:
                    </h6>
                    <c:set var="totalUnpaidInvoices" value="${invoices.size()}" />
                    <div>
                        <span class="badge bg-danger me-1">Chưa thanh toán: ${totalUnpaidInvoices}</span>
                        <c:if test="${totalUnpaidInvoices == 0}">
                            <span class="badge bg-success">Không có hóa đơn nợ</span>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="text-center p-5">
            <i class="bi bi-receipt text-muted" style="font-size: 3rem;"></i>
            <h5 class="text-muted mt-3">Chưa có hóa đơn nào</h5>
            <p class="text-muted">Phòng này chưa có hóa đơn nào được tạo</p>
        </div>
    </c:otherwise>
</c:choose>

<script>
function markAsPaid(invoiceId) {
    if (confirm('Bạn có chắc chắn muốn đánh dấu hóa đơn này là đã thanh toán?')) {
        // Create form and submit
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/admin/bills/update-status/' + invoiceId;
        
        const statusInput = document.createElement('input');
        statusInput.type = 'hidden';
        statusInput.name = 'status';
        statusInput.value = 'PAID';
        
        form.appendChild(statusInput);
        document.body.appendChild(form);
        form.submit();
    }
}
</script>