-- Overall model performance
SELECT * 
FROM cnn_performance;

-- Confusion matrix
SELECT True_Label, Predicted_Label, COUNT(*) AS Count
FROM cnn_results
GROUP BY True_Label, Predicted_Label
ORDER BY True_Label, Predicted_Label;

-- Confidence distribution
SELECT CASE 
		WHEN Confidence_Score >= 0.8 THEN 'High (≥0.8)'
		WHEN Confidence_Score >= 0.6 THEN 'Medium (0.6-0.8)'
		ELSE 'Low (<0.6)'
END AS Confidence_Level, COUNT(*) AS Count, ROUND(AVG(CASE WHEN Correct_Prediction = 1 THEN 1.0 ELSE 0.0 END), 3) AS Accuracy
FROM cnn_results
GROUP BY CASE 
		WHEN Confidence_Score >= 0.8 THEN 'High (≥0.8)'
		WHEN Confidence_Score >= 0.6 THEN 'Medium (0.6-0.8)'
        ELSE 'Low (<0.6)'
END;
    
-- Performance by image density
SELECT CASE 
        WHEN i.Average_Density < 2.0 THEN 'Low Density (<2.0)'
        WHEN i.Average_Density < 2.5 THEN 'Medium Density (2.0-2.5)'
        ELSE 'High Density (≥2.5)'
END AS Density_Group, COUNT(*) AS Count, ROUND(AVG(c.Confidence_Score), 3) AS Avg_Confidence,
ROUND(AVG(CASE WHEN c.Correct_Prediction = 1 THEN 1.0 ELSE 0.0 END), 3) AS Accuracy
FROM cnn_results AS c
JOIN image_data AS i ON c.Image_ID = i.Image_ID
GROUP BY 
    CASE 
        WHEN i.Average_Density < 2.0 THEN 'Low Density (<2.0)'
        WHEN i.Average_Density < 2.5 THEN 'Medium Density (2.0-2.5)'
        ELSE 'High Density (≥2.5)'
    END;
    
--  Incorrect predictions
SELECT 
    m.CNN_ID,
    m.Inspection_ID,
    m.True_Label,
    m.Predicted_Label,
    m.Confidence_Score,
    i.Average_Density,
    pt.PN
FROM main_view AS m
JOIN image_data AS i ON m.Image_ID = i.Image_ID
LEFT JOIN parts pt ON m.SN_ID = pt.SN_ID
WHERE m.Correct_Prediction = 0
ORDER BY m.Confidence_Score DESC;