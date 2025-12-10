# Architecture: Static Website on S3

     ┌─────────────────┐
     │   User Browser  │
     └────────┬────────┘
              │ HTTPS
     ┌────────▼────────┐
     │  AWS CloudFront │  (Optional CDN)
     └────────┬────────┘
              │
     ┌────────▼────────┐
     │   S3 Bucket     │
     │  (us-east-1)    │
     ├─────────────────┤
     │ • index.html    │
     │ • styles.css    │
     │ • script.js     │
     │ • images/       │
     └─────────────────┘