package pfoxit.carhub.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "cars")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Car {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private RentalOffice rentalOffice;

    @ManyToOne
    private CarCategory category;

    @Column(nullable = false)
    private String brand;

    @Column(nullable = false)
    private String model;

    @Column(nullable = false)
    private Integer year;

    private String color;

    @Column(unique = true, nullable = false)
    private String registrationNumber;

    @Column(unique = true, nullable = false)
    private String vinNumber;

    private Integer mileage;

    @Enumerated(EnumType.STRING)
    private FuelType fuelType;

    @Enumerated(EnumType.STRING)
    private Transmission transmission;

    private Integer numberOfSeats;

    private Boolean airConditioning;

    private Boolean navigationSystem;

    @Enumerated(EnumType.STRING)
    private CarStatus currentStatus;

    private BigDecimal dailyRate;

    private String imageUrl;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    public enum FuelType {PETROL, DIESEL, ELECTRIC, HYBRID}

    public enum Transmission {MANUAL, AUTOMATIC}

    public enum CarStatus {AVAILABLE, RENTED, IN_SERVICE, UNAVAILABLE}

}
