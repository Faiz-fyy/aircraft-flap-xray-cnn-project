CREATE TABLE image_data (
    Image_ID VARCHAR(10) PRIMARY KEY,
    Average_Density DOUBLE,
    Width INT,
    Height INT,
    Folder VARCHAR(10)
);

CREATE TABLE cnn_results (
    CNN_ID VARCHAR(10) PRIMARY KEY,
    Image_ID VARCHAR(10),
    Inspection_ID VARCHAR(10),
    True_Label VARCHAR(10),
    Predicted_Label VARCHAR(10),
    Confidence_Score DOUBLE,
    Correct_Prediction bool,
    FOREIGN KEY (Image_ID) REFERENCES image_data(Image_ID)
);

-- Update existing records(E449a & E449b) (E430a & E430b)
UPDATE inspections SET Inspection_ID = 'E449a' WHERE Inspection_ID = 'E449';
UPDATE inspections SET Inspection_ID = 'E430b' WHERE Inspection_ID = 'E430';
INSERT INTO inspections VALUES ('E449b', 'D449', 'ID449', 'P449', 1, 1);
INSERT INTO inspections VALUES ('E430a', 'D430', 'ID430', 'P430', 1, 0);

-- Primary performance indexes
CREATE INDEX idx_cnn_inspection ON cnn_results(Inspection_ID);
CREATE INDEX idx_cnn_confidence ON cnn_results(Confidence_Score);
CREATE INDEX idx_cnn_correct ON cnn_results(Correct_Prediction);
CREATE INDEX idx_cnn_labels ON cnn_results(True_Label, Predicted_Label);

-- Image data indexes
CREATE INDEX idx_img_density ON image_data(Average_Density);
CREATE INDEX idx_img_dimensions ON image_data(Width, Height);

-- Main view (because why not?)
CREATE VIEW main_view AS
SELECT 
    c.CNN_ID,
    c.Image_ID,
    c.Inspection_ID,
    c.True_Label,
    c.Predicted_Label,
    c.Confidence_Score,
    c.Correct_Prediction,
    i.Average_Density,
    i.Width,
    i.Height,
    -- Join with original inspection data
    ins.Date_ID,
    ins.SN_ID,
    ins.Parameters_ID,
    ins.Water AS Original_Water,
    ins.Disbond,
    rd.Relative_Day,
    rd.Rain_Season,
    p.mAm,
    p.SFD,
    pt.PN
FROM cnn_results AS c
JOIN image_data AS i ON c.Image_ID = i.Image_ID
LEFT JOIN inspections AS ins ON c.Inspection_ID = ins.Inspection_ID
LEFT JOIN relative_date AS rd ON ins.Date_ID = rd.Date_ID
LEFT JOIN parameters AS p ON ins.Parameters_ID = p.Parameters_ID
LEFT JOIN parts AS pt ON ins.SN_ID = pt.SN_ID;

-- CNN Performance View
CREATE VIEW cnn_performance AS
SELECT 
    'Overall' AS Category,
    COUNT(*) AS Total_Predictions,
    SUM(CASE WHEN Correct_Prediction = 1 THEN 1 ELSE 0 END) AS Correct,
    ROUND(AVG(CASE WHEN Correct_Prediction = 1 THEN 1.0 ELSE 0.0 END), 3) AS Accuracy,
    ROUND(AVG(Confidence_Score), 3) AS Avg_Confidence
FROM cnn_results
UNION ALL
SELECT 
    CONCAT(True_Label, ' Detection') AS Category,
    COUNT(*) AS Total_Predictions,
    SUM(CASE WHEN Correct_Prediction = 1 THEN 1 ELSE 0 END) AS Correct,
    ROUND(AVG(CASE WHEN Correct_Prediction = 1 THEN 1.0 ELSE 0.0 END), 3) AS Accuracy,
    ROUND(AVG(Confidence_Score), 3) AS Avg_Confidence
FROM cnn_results
GROUP BY True_Label;