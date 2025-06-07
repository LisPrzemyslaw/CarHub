package pfoxit.carhub.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "reservations")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Reservation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private User user;

    @ManyToOne
    private Car car;

    @ManyToOne
    private RentalOffice rentalOfficePickup;

    @ManyToOne
    private RentalOffice rentalOfficeReturn;

    @Column(nullable = false)
    private LocalDateTime startDate;

    @Column(nullable = false)
    private LocalDateTime endDate;

    private LocalDateTime actualReturnDate;

    @Enumerated(EnumType.STRING)
    private ReservationStatus status;

    private BigDecimal totalPrice;

    private Boolean depositPaid;

    private String notes;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    public enum ReservationStatus {PENDING, CONFIRMED, IN_PROGRESS, COMPLETED, CANCELLED}
}
