import { useState, useCallback } from "react";

export default function Home() {
  const [file, setFile] = useState(null);
  const [complexity, setComplexity] = useState(0.5);
  const [depth, setDepth] = useState(5.0);
  const [previewData, setPreviewData] = useState(null);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(false);
  const [isDragging, setIsDragging] = useState(false);

  const onDrop = useCallback((e) => {
    e.preventDefault();
    e.stopPropagation();
    setIsDragging(false);
    const f = e.dataTransfer?.files?.[0];
    if (f) {
      setFile(f);
      setPreviewData(null);
      setError(null);
    }
  }, []);

  const onDragOver = useCallback((e) => {
    e.preventDefault();
    e.stopPropagation();
    setIsDragging(true);
  }, []);

  const onDragLeave = useCallback((e) => {
    e.preventDefault();
    e.stopPropagation();
    setIsDragging(false);
  }, []);

  const handlePreview = async () => {
    setError(null);
    if (!file) {
      setError('Please select a file');
      return;
    }
    const formData = new FormData();
    formData.append("file", file);
    formData.append("complexity", String(complexity));
    formData.append("depth", String(depth));
    try {
      setLoading(true);
      const apiUrl = process.env.NEXT_PUBLIC_API_URL || "http://127.0.0.1:8000";
      const res = await fetch(`${apiUrl}/preview-only`, {
        method: "POST",
        body: formData
      });
      if (!res.ok) {
        // Try to parse JSON error from FastAPI
        let msg = `Request failed with ${res.status}`;
        try {
          const data = await res.json();
          msg = data?.detail || msg;
        } catch {
          try {
            msg = await res.text();
          } catch {}
        }
        throw new Error(msg);
      }
      const data = await res.json();
      setPreviewData(data);
    } catch (e) {
      setError(e.message || String(e));
    }
    finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ padding: "2rem", fontFamily: "Arial" }}
         onDrop={onDrop}
         onDragOver={onDragOver}
         onDragLeave={onDragLeave}
    >
      <h1>Design Fill Pro - Local Test</h1>
      <div style={{ margin: "0.5rem 0" }}>
        <input type="file" onChange={(e) => { setFile(e.target.files[0]); setPreviewData(null); setError(null); }} />
      </div>
      <div
        style={{
          border: "2px dashed #888",
          padding: "1rem",
          borderRadius: 8,
          background: isDragging ? "#eef" : "#fafafa",
          color: "#555"
        }}
      >
        Drag & drop an image here
      </div>
      <div style={{ margin: "0.5rem 0" }}>
        <label>Complexity (0.0 - 1.0): </label>
        <input
          type="number"
          step="0.1"
          min="0"
          max="1"
          value={complexity}
          onChange={(e) => setComplexity(parseFloat(e.target.value))}
          style={{ width: 100 }}
        />
      </div>
      <div style={{ margin: "0.5rem 0" }}>
        <label>Depth (1 - 1000): </label>
        <input
          type="number"
          step="1"
          min="1"
          max="1000"
          value={depth}
          onChange={(e) => setDepth(parseFloat(e.target.value))}
          style={{ width: 100 }}
        />
      </div>
      <button onClick={handlePreview} disabled={loading}>
        {loading ? 'Uploading…' : 'Generate Preview'}
      </button>
      {error && (
        <div style={{
          color: '#721c24',
          background: '#f8d7da',
          border: '1px solid #f5c6cb',
          padding: '0.5rem',
          borderRadius: 4,
          marginTop: '0.5rem'
        }}>
          {error}
        </div>
      )}
      {previewData && (
        <pre style={{ marginTop: "1rem" }}>
          {JSON.stringify(previewData, null, 2)}
        </pre>
      )}

      {previewData?.preview_url && (
        <div style={{ marginTop: "1rem" }}>
          <div>Preview:</div>
          <img src={`${process.env.NEXT_PUBLIC_API_URL || "http://127.0.0.1:8000"}${previewData.preview_url}`} alt="preview" style={{ maxWidth: 300 }} />
        </div>
      )}
    </div>
  );
}