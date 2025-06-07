package pfoxit.carhub.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "car_categories")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CarCategory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    private String description;

    @Column(nullable = false)
    private BigDecimal dailyRate;

    @Column(nullable = false)
    private BigDecimal depositAmount;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;
}
