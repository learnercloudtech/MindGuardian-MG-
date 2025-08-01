# 🧠 MindGuardian

MindGuardian is a modular, emotion-aware mental wellness companion built with Flutter. It empowers users to track moods, reflect on meals and workouts, engage in empathetic journaling, and receive personalized support — all powered by Agentic AI.

---

## 🚀 Overview

MindGuardian was developed in two phases:

### 🔹 Prototype v0 – Local Granite Backend
- Integrated locally hosted **Granite 3.1-Dense-2B** via `ngrok`
- Used **Flutter + Hive + Firebase Firestore**
- Granite provided emotion classification and empathetic responses
- Demo captured showcasing offline + tunneled AI interaction

### 🔹 Prototype v1 – AWS-Based Cloud Implementation
- Migrated to **AWS Lambda (NovaResponder)** + **API Gateway**
- Used **S3** for storing mood logs and **Firestore** for cloud sync
- Integrated **Data Prep Kit** for training/testing diverse emotional inputs
- Demo captured showcasing real-time cloud-based AI interaction

---

## 🧩 Features

- ✅ Mood tracking with emotion analysis and journaling
- ✅ Exercise and diet reflection with wellness suggestions
- ✅ StudyBuddy AI for academic support
- ✅ Crisis detection and escalation to support resources
- ✅ Modular tool architecture for scalable wellness features
- ✅ Empathetic responses powered by Agentic AI

---

## 🎯 Mental Health Technology Alignment

MindGuardian supports **Theme 2: Mental Health Technology Support**:

### Subtopic 2A: Stress Pattern Recognition and Detection
- Emotion tagging and stress scoring via AI
- RAG-ready architecture for psychological literature grounding

### Subtopic 2B: Personalized Mental Wellness Recommendations
- Modular tools + Data Prep Kit for tailored suggestions
- Agentic AI adapts responses based on user behavior

### Subtopic 2C: Crisis Intervention Bot
- Risk score logic triggers escalation to clinician contact
- Empathetic tone and context-aware support

---

## 🛠️ Technologies Used

### Prototype v0
- Flutter, Hive, Firebase Firestore
- Granite 3.1-Dense-2B (local)
- ngrok (secure tunnel)

### Prototype v1
- Flutter, Hive, Firestore
- AWS Lambda (NovaResponder), API Gateway (with key)
- AWS S3, IAM Roles
- Data Prep Kit

---

## 📈 Future Roadmap

- 🔄 Age-based emotion risk scoring
- 🧠 Voice journaling and speech pattern analysis
- 📊 Clinician dashboard for emotional trends
- 🌍 Multi-age interaction design

---

## 📦 Getting Started

To run the app locally:

```bash
flutter pub get
flutter run
