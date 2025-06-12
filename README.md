# Aircraft Flap X-Ray CNN Analysis

![Python](https://img.shields.io/badge/Python-3.8+-blue) ![TensorFlow](https://img.shields.io/badge/TensorFlow-2.x-orange) ![Computer Vision](https://img.shields.io/badge/CV-CNN-red) ![Industry](https://img.shields.io/badge/Industry-Aviation-green) ![Database](https://img.shields.io/badge/Database-MySQL-yellow)

**Deep learning application for water ingression detection in aircraft flap using X-ray radiography analysis**

*NDT Engineering to Data Science career transition project - Advanced computer vision and transfer learning*

## Project Overview

This project develops a Convolutional Neural Network (CNN) for automated detection of water ingression in aircraft trailing edge flap structures using X-ray radiographic images. Building upon previous predictive analytics work (Aircraft Flap Water Ingression Predictive Analytics), this initiative demonstrates computer vision capabilities for digital transformation in aviation NDT operations.

**Final Achievement: 88.9% accuracy using ResNet50 transfer learning with confidence scoring for safety-critical applications**

## Business Problem

Traditional X-ray film interpretation for water ingression detection relies entirely on human expertise, creating bottlenecks in inspection workflows and potential for human error. As aviation MRO operations move toward digital radiography, automated analysis capabilities become essential for:

- Consistency: Eliminating subjective interpretation variations
- Efficiency: Reducing inspection turnaround times
- Safety: Providing systematic confidence assessment for critical decisions
- Scalability: Supporting increased inspection volumes with digital workflows

### Dataset Characteristics
- 139 X-ray film photographs captured with smartphone (Pixel 7 Pro)
- Class distribution: 60% Water vs. 40% No Water (well-balanced)
- Multi-format capture: DNG + JPEG pairs from physical radiographs
- Manual ROI preprocessing: GIMP-based honeycomb area extraction

### Data Governance Note
- CNN Training Dataset: 139 images (maximizing available labeled data)
- Database Records: 138 images (maintaining complete audit trail)
- Rationale: One image lacks traceable exposure ID - included in training for performance but excluded from database for integrity

## Technical Development Process

### Phase 1: Custom CNN Attempt (Initial Failure)
**Approach:**
- Simple architecture: 16→32→64 filter progression
- Training: 133 images with standard augmentation
- Result: ~50% accuracy (random guessing performance)

**Learning:** Small specialized datasets require transfer learning, not custom architectures.

### Phase 2: Transfer Learning Implementation
**ResNet50 Strategy:**
- Two-phase progressive training
  - Phase 1: Frozen ResNet50 base (58% accuracy)
  - Phase 2: Fine-tuned top 20 layers (81% accuracy)
- Grayscale→RGB conversion for ImageNet compatibility
- Result: 81% accuracy (exceeded 75% target)

### Phase 3: Reproducibility Challenge
**Problem:** Results varied 60%-80% across identical runs
**Solution:** Complete deterministic pipeline implementation
```python
# Reproducibility fix
random.seed(42)
np.random.seed(42)
tf.random.set_seed(42)
os.environ['TF_DETERMINISTIC_OPS'] = '1'
```
**Outcome:** 100% consistent results across all runs

### Phase 4: Final Optimization
**Dataset Refinement:** Added 6 uncertain images after expert review
**Final Performance:** 88.9% accuracy with full reproducibility

## Model Performance

### Results Summary
| Metric | Performance |
|--------|-------------|
| Accuracy | 88.9% |
| Precision (Water) | 93% |
| Precision (Nil) | 83% |
| Recall (Water) | 88% |
| Recall (Nil) | 91% |
| ROC AUC | 0.90 |

### Confusion Matrix
|  | Predicted Nil | Predicted Water |
|--|---------------|-----------------|
| **Actual Nil** | 53 | 2 |
| **Actual Water** | 4 | 79 |

### Confidence Scoring Framework
| Confidence Level | Count | Accuracy | Recommendation |
|------------------|-------|----------|----------------|
| High (≥80%) | 72 | 100% | Automated decision |
| Medium (60-80%) | 8 | 87.5% | Senior review |
| Low (<60%) | 58 | 91.4% | Manual verification required |

## Technical Implementation

### Transfer Learning Optimization
- Grayscale adaptation: RGB conversion maintaining X-ray characteristics
- Progressive training: Systematic layer unfreezing for optimal fine-tuning
- Deterministic pipeline: Complete reproducibility for production deployment

### Safety-Critical Confidence Scoring
```python
def interpret_prediction(confidence_score):
    if confidence_score > 0.8:
        return "HIGH CONFIDENCE: Automated decision"
    elif confidence_score > 0.6:
        return "MEDIUM CONFIDENCE: Senior review"
    else:
        return "LOW CONFIDENCE: Manual verification required"
```

### Database Integration
**Schema Extension** (Aircraft Flap Water Ingression Predictive Analytics Project continuation):
```sql
CREATE TABLE image_data (
    Image_ID VARCHAR(10) PRIMARY KEY,
    Average_Density DOUBLE,
    Width INT,
    Height INT
);

CREATE TABLE cnn_results (
    CNN_ID VARCHAR(10) PRIMARY KEY,
    Image_ID VARCHAR(10),
    Inspection_ID VARCHAR(10),
    True_Label VARCHAR(10),
    Predicted_Label VARCHAR(10),
    Confidence_Score DOUBLE,
    Correct_Prediction BOOL
);
```

## Business Intelligence Insights

### Performance Analysis
- Overall Accuracy: 95.7% (132/138 correct predictions)
- Nil Detection: 96.4% accuracy (critical for preventing false alarms)
- Water Detection: 95.2% accuracy (essential for safety)
- High Confidence Reliability: 100% accuracy in 72 high-confidence cases

### Operational Recommendations
1. Immediate Deployment: High-confidence predictions (≥80%) for automated triage
2. Workflow Integration: Medium/low confidence cases trigger human review
3. Quality Assurance: Conservative approach ensures safety compliance
4. Future Scaling: Database architecture ready for digital radiography integration

## Key Learnings & Methodology

### Technical Lessons
1. Transfer Learning Superiority: ResNet50 outperformed custom CNN by +38.9%
2. Reproducibility Importance: Deterministic operations essential for production
3. Preprocessing Consistency: Training/validation/testing pipeline alignment crucial
4. Conservative Confidence: Safety-critical applications require manual review triggers

### Domain Integration
- NDT Expertise: Honeycomb composite structure understanding
- Aviation Safety: Conservative decision-making for critical applications
- Digital Transformation: Bridge between traditional film and digital workflows
- Proof-of-Concept Value: Demonstrates AI feasibility for specialized NDT applications

## Technologies & Architecture

**Deep Learning Stack:**
- Framework: TensorFlow 2.19.0 with Keras
- Architecture: ResNet50 transfer learning
- Preprocessing: ImageDataGenerator with custom augmentation
- Optimization: Adam optimizer with learning rate scheduling

**Data Engineering:**
- Database: MySQL with normalized schema extension
- Image Processing: GIMP → PIL → TensorFlow pipeline
- Reproducibility: Complete deterministic implementation
- Quality Control: Multi-source validation and metadata tracking

**Visualization & Analysis:**
- Model Performance: Confusion matrices, ROC curves, training history
- Feature Analysis: ResNet50 filter visualization
- Business Intelligence: Confidence distribution and performance metrics

## Project Structure

```
├── notebooks/              # Final CNN implementation
│   └── Aircraft Flap X-Ray CNN Analysis.ipynb
├── database/               # Schema extension and queries
│   ├── Schema Extension.sql
│   └── Example Queries.sql
├── visualizations/         # Model analysis and dashboards
│   ├── dashboards/         # Tableau performance dashboards
│   └── model_analysis/     # Training curves and confusion matrices
├── docs/                   # Methodology documentation
│   └── Project Methodology.md
└── README.md               # Project overview
```

## Results & Business Impact

### Technical Achievements
- Target Performance: 88.9% vs. 70-75% target (+13.9-18.9%)
- Reproducibility: 100% consistent results across runs
- Conservative Framework: 100% accuracy in high-confidence predictions
- Database Coverage: 138 images with complete metadata integration

### Operational Impact
- Proof-of-Concept: Validated AI approach for specialized NDT applications
- Digital Readiness: Architecture prepared for digital radiography transition
- Safety Framework: Conservative confidence scoring for critical decisions
- Technical Development: Advanced computer vision and transfer learning implementation

### Business Value
- Innovation Application: CNN implementation in aviation NDT
- Scalability: Database architecture ready for enterprise deployment
- Risk Management: Systematic confidence assessment for operational safety
- Future Integration: Clear pathway for digital transformation initiatives

## Limitations & Future Work

### Current Limitations
- Dataset Size: 138 images (sufficient for proof-of-concept, limited for production)
- Image Source: Smartphone photography of physical films (interim solution)
- Domain Specificity: Tailored for trailing edge flap water ingression only

### Enhancement Roadmap
**Technical Improvements:**
- Direct digital radiography integration
- Expanded dataset with multi-aircraft types
- Advanced ensemble methods implementation
- Real-time prediction pipeline development

**Business Applications:**
- CMMS system integration for automated work orders
- Multi-defect detection capability (cracks, delamination, corrosion)
- Regulatory documentation automation
- Cross-platform deployment architecture

## Conclusion

This project successfully demonstrates the application of advanced computer vision techniques to safety-critical aviation NDT challenges. The progression from custom CNN failure (50%) to optimized transfer learning success (88.9%) illustrates systematic problem-solving and technical adaptability essential for real-world AI implementation.

The work establishes a foundation for computer vision capabilities in aviation MRO digital transformation while maintaining the rigorous safety standards essential to the industry. This represents the culmination of systematic skill development in applying data science to aviation safety challenges, progressing from traditional analytics to advanced computer vision implementation.

---

**About:** This project represents the progression from traditional analytics (Aircraft Flap Water Ingression Predictive Analytics & Aircraft Hub Inspection Predictive Modeling) to advanced computer vision, demonstrating comprehensive technical capability and domain expertise for AI applications in safety-critical industries.
