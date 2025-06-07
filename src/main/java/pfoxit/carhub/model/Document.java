package pfoxit.carhub.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "documents")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Document {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private Reservation reservation;

    @Enumerated(EnumType.STRING)
    private DocumentType documentType;

    private String filePath;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    public enum DocumentType {CONTRACT, INVOICE, DAMAGE_REPORT, INSURANCE}
}
