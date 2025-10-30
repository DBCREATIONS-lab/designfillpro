<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Design Fill Pro</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: white;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: rgba(255,255,255,0.1);
            padding: 40px;
            border-radius: 20px;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
        }
        h1 {
            text-align: center;
            font-size: 3em;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        .upload-area {
            border: 3px dashed rgba(255,255,255,0.5);
            border-radius: 15px;
            padding: 40px;
            text-align: center;
            margin: 20px 0;
            background: rgba(255,255,255,0.05);
            transition: all 0.3s ease;
        }
        .upload-area:hover {
            border-color: rgba(255,255,255,0.8);
            background: rgba(255,255,255,0.1);
        }
        .controls {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin: 20px 0;
        }
        .control-group {
            background: rgba(255,255,255,0.1);
            padding: 20px;
            border-radius: 10px;
        }
        label {
            display: block;
            margin-bottom: 10px;
            font-weight: bold;
        }
        input[type="file"], input[type="number"], input[type="range"] {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 5px;
            background: rgba(255,255,255,0.2);
            color: white;
            font-size: 16px;
        }
        input[type="file"]::file-selector-button {
            background: rgba(255,255,255,0.3);
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            color: white;
            cursor: pointer;
        }
        .btn {
            background: linear-gradient(45deg, #ff6b6b, #ee5a24);
            border: none;
            padding: 15px 30px;
            border-radius: 25px;
            color: white;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            transition: transform 0.2s ease;
            display: block;
            margin: 20px auto;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }
        .status {
            text-align: center;
            font-size: 18px;
            margin: 20px 0;
        }
        .preview {
            background: rgba(255,255,255,0.1);
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1> Design Fill Pro</h1>
        <p style="text-align: center; font-size: 1.2em; margin-bottom: 30px;">
            Professional Image Processing & Design Tool
        </p>
        
        <div class="upload-area" id="uploadArea">
            <h3> Upload Your Image</h3>
            <p>Drag & drop an image here or click to browse</p>
            <input type="file" id="fileInput" accept="image/*" style="display: none;">
            <div id="fileName" style="margin-top: 10px; font-weight: bold;"></div>
        </div>

        <div class="controls">
            <div class="control-group">
                <label for="complexity"> Complexity Level:</label>
                <input type="range" id="complexity" min="0" max="1" step="0.1" value="0.5">
                <span id="complexityValue">0.5</span>
            </div>
            <div class="control-group">
                <label for="depth"> Processing Depth:</label>
                <input type="range" id="depth" min="1" max="1000" step="1" value="5">
                <span id="depthValue">5</span>
            </div>
        </div>

        <button class="btn" id="processBtn" onclick="processImage()">
             Process Image
        </button>

        <div class="status" id="status">
            Ready to process your images!
        </div>

        <div class="preview" id="preview" style="display: none;">
            <h3>Preview Result</h3>
            <div id="previewContent"></div>
        </div>

        <div style="text-align: center; margin-top: 40px; opacity: 0.8;">
            <p> Powered by FastAPI & Next.js |  Live on GitHub Pages</p>
            <p> Status: Frontend Demo Mode (Backend deployment in progress)</p>
        </div>
    </div>

    <script>
        const uploadArea = document.getElementById('uploadArea');
        const fileInput = document.getElementById('fileInput');
        const fileName = document.getElementById('fileName');
        const complexitySlider = document.getElementById('complexity');
        const depthSlider = document.getElementById('depth');
        const complexityValue = document.getElementById('complexityValue');
        const depthValue = document.getElementById('depthValue');
        const status = document.getElementById('status');
        let selectedFile = null;

        // File upload handling
        uploadArea.onclick = () => fileInput.click();
        
        fileInput.onchange = (e) => {
            selectedFile = e.target.files[0];
            if (selectedFile) {
                fileName.textContent = Selected: $;
                status.textContent = 'Image selected! Ready to process.';
            }
        };

        // Drag and drop
        uploadArea.ondragover = (e) => {
            e.preventDefault();
            uploadArea.style.borderColor = 'rgba(255,255,255,0.8)';
        };

        uploadArea.ondragleave = () => {
            uploadArea.style.borderColor = 'rgba(255,255,255,0.5)';
        };

        uploadArea.ondrop = (e) => {
            e.preventDefault();
            uploadArea.style.borderColor = 'rgba(255,255,255,0.5)';
            selectedFile = e.dataTransfer.files[0];
            if (selectedFile) {
                fileName.textContent = Selected: $;
                status.textContent = 'Image selected! Ready to process.';
            }
        };

        // Slider updates
        complexitySlider.oninput = () => {
            complexityValue.textContent = complexitySlider.value;
        };

        depthSlider.oninput = () => {
            depthValue.textContent = depthSlider.value;
        };

        // Process image function
        function processImage() {
            if (!selectedFile) {
                status.textContent = ' Please select an image first!';
                return;
            }

            status.textContent = ' Processing your image...';
            
            // Simulate processing (replace with actual API call when backend is ready)
            setTimeout(() => {
                const preview = document.getElementById('preview');
                const previewContent = document.getElementById('previewContent');
                
                previewContent.innerHTML = 
                    <p><strong> Processing Complete!</strong></p>
                    <p> File: $</p>
                    <p> Complexity: $</p>
                    <p> Depth: $</p>
                    <p> Size: $ MB</p>
                    <div style="margin: 20px 0; padding: 20px; background: rgba(255,255,255,0.1); border-radius: 10px;">
                        <p> <strong>Backend Integration Status:</strong></p>
                        <p>Frontend:  Live on GitHub Pages</p>
                        <p>Backend API:  Deployment in progress</p>
                        <p>Full functionality will be available once backend deployment completes.</p>
                    </div>
                ;
                
                preview.style.display = 'block';
                status.textContent = ' Demo processing complete! Full API integration coming soon.';
            }, 2000);
        }

        // Initialize
        document.addEventListener('DOMContentLoaded', () => {
            status.textContent = ' Design Fill Pro is live! Upload an image to get started.';
        });
    </script>
</body>
</html>
