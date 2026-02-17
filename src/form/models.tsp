using Http;

namespace CoreSystem.Forms {
	@doc("The request body for uploading a cover image. The frontend should send images in WebP format with max-width/height: 1800px and quality 80%.")
	model FormCoverUploadRequest {
		coverImage: HttpPart<bytes>;
	}

	@doc("Response after uploading a cover image.")
	@example(#{ imageUrl: "https://example.com/images/form-cover-123.webp" })
	model FormCoverUploadResponse {
		@doc("The temporary full URL of the uploaded image.")
		imageUrl: string;
	}

	@doc("The request body for creating/updating a form.")
	@example(#{ title: "Enter SDC Form", description: "If you want to join us, just fill in this form!", messageAfterSubmission: "Thank you for your submission!" })
	model FormRequest {
		@doc("The title of the form.")
		title: string;

		@doc("The description of the form.")
		description: string;

		@doc("(Optional) Preview text for the form. If not provided, fallback to first 25 characters of description.")
		previewMessage?: string;

		@doc("(Optional) Deadline for form completion.")
		deadline?: utcDateTime;

		@doc("When the form is available to be filled.")
		publishTime?: utcDateTime;

		@doc("The message to show after user's submission.")
		messageAfterSubmission: string;

		@doc("The dressing of the form.")
		dressing?: FormDressing;

		@doc("The image path returned by the upload API.")
		coverImage?: string;

		@doc("The google sheet url this form's responses will be sent to.")
		googleSheetUrl?: string;

		@doc("The visibility setting of the form. Public forms are visible to all logged-in users. Private forms require a direct link to access.")
		visibility?: FormVisibility;
	}

	@doc("The structure of a form.")
	@example(#{
		id: "9a843aa0-8451-4e3b-b6a0-8c0e994e9040",
		title: "SDC 2025 Recruitment Form",
		description: "Join us for an exciting journey in software development!",
		previewMessage: "Join us for an exciting journey",
		status: FormStatus.published,
		unitId: "d26e9c90-4747-496b-9953-7e7c4f97643f",
		lastEditor: "3c5fa073-7b97-43a3-bc44-ddc98f390a08",
		deadline: utcDateTime.fromISO("2025-03-31T23:59:59Z"),
		publishTime: utcDateTime.fromISO("2025-02-01T00:00:00Z"),
		messageAfterSubmission: "Thank you for your application! We'll get back to you soon.",
		dressing: #{ color: "#0066cc", headerFont: "LINESeedTW", questionFont: "LINESeedTW", textFont: "LINESeedTW" },
	coverImage: "https://placehold.co/1800x600/0066cc/white.webp?text=SDC+2025+Recruitment",
		googleSheetUrl: "https://docs.google.com/spreadsheets/d/1ABC123/edit",
		visibility: FormVisibility.public,
		createdAt: utcDateTime.fromISO("2025-01-15T10:00:00Z"),
		updatedAt: utcDateTime.fromISO("2025-02-10T14:30:00Z"),
	})
	model Form {
		@doc("The form's unique identifier.")
		id: uuid;

		@doc("The title of the form.")
		title: string;

		@doc("The description written in the form to show user info.")
		description: string;

		@doc("Preview text. If not provided, fallback to first 25 characters of description.")
		previewMessage: string;

		@doc("The status of this form.")
		status: FormStatus;

		@doc("The unit this form belongs to.")
		unitId: uuid;

		@doc("The user who last editted the form.")
		lastEditor: uuid;

		@doc("(Optional) Deadline for form completion. If not specified, returns null.")
		deadline?: utcDateTime;

		@doc("When the form is available to be filled.")
		publishTime?: utcDateTime;

		@doc("The message to show after user's submission.")
		messageAfterSubmission: string;

		@doc("The dressing of the form.")
		dressing?: FormDressing;

		@doc("The full URL to access the cover image.")
		coverImage?: string;

		@doc("The google sheet url this form's responses will be sent to.")
		googleSheetUrl?: string;

		@doc("The visibility setting of the form. Public forms are visible to all logged-in users. Private forms require a direct link to access.")
		visibility: FormVisibility;

		@doc("The creation timestamp of the form.")
		createdAt: utcDateTime;

		@doc("The last updated timestamp of the form")
		updatedAt: utcDateTime;
	}

	@doc("The appearance/dressing configuration for a form.")
	@example(#{ color: "#0066cc", headerFont: "LINESeedTW", questionFont: "LINESeedTW", textFont: "LINESeedTW" })
	model FormDressing {
		@doc("Color in hex format (e.g., #0066cc)")
		color?: string;

		@doc("Header font id from https://font.emtech.cc/list")
		headerFont?: string;

		@doc("Question font id from https://font.emtech.cc/list")
		questionFont?: string;

		@doc("Text font id from https://font.emtech.cc/list")
		textFont?: string;
	}

	@doc("A section within a form, grouping questions together.")
	@example(#{
		id: "b23f2668-c2dc-4213-88fe-eceedff46398",
		formId: "9a843aa0-8451-4e3b-b6a0-8c0e994e9040",
		title: "Personal Information",
		description: "Please provide your basic information",
		questions: #[],
	})
	model Section {
		@doc("Unique identifier.")
		id: uuid;

		@doc("The form this section belongs to.")
		formId: uuid;

		@doc("Section title (e.g., 'Group Info').")
		title: string;

		@doc("Section description.")
		description?: string;

		@doc("The questions of the section.")
		questions: QuestionResponse[];
	}

	@doc("The current progress of a section")
	enum SectionProgress {
		@doc("User hasn't started or not finished.")
		draft: "DRAFT",

		@doc("User has completed/passed this response.")
		submitted: "SUBMITTED",
	}

	@doc("The current status of a form.")
	enum FormStatus {
		draft: "DRAFT",
		published: "PUBLISHED",

		@doc("Archived: form is hidden from default listings but is still stored and can be accessed directly.")
		archived: "ARCHIVED",
	}

	@doc("The visibility setting of a form. Public forms are visible to all logged-in users. Private forms require a direct link to access.")
	enum FormVisibility {
		@doc("Public: visible to all logged-in users")
		public: "PUBLIC",

		@doc("Private: requires a direct link to access")
		private: "PRIVATE",
	}

	@doc("Response model for listing all sections and questions in a form.")
	@example(#{ 
		sections: #[
			#{
				id: "b23f2668-c2dc-4213-88fe-eceedff46398",
				formId: "9a843aa0-8451-4e3b-b6a0-8c0e994e9040",
				title: "Personal Information",
				description: "Please provide your basic information",
				questions: #[
					#{
						id: "ee894524-4bd8-4a64-8fd2-a53b39ca94cd",
						sectionId: "b23f2668-c2dc-4213-88fe-eceedff46398",
						required: true,
						type: QuestionTypes.shortText,
						title: "Full Name",
						description: "Please enter your full name (in English)",
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "f2a1b3c4-5d6e-7f8a-9b0c-1d2e3f4a5b6c",
						sectionId: "b23f2668-c2dc-4213-88fe-eceedff46398",
						required: true,
						type: QuestionTypes.shortText,
						title: "Student ID",
						description: "Enter your student ID number",
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "a3b4c5d6-7e8f-9a0b-1c2d-3e4f5a6b7c8d",
						sectionId: "b23f2668-c2dc-4213-88fe-eceedff46398",
						required: true,
						type: QuestionTypes.shortText,
						title: "Email Address",
						description: "Please provide your email address",
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "d4e5f6a7-8b9c-0d1e-2f3a-4b5c6d7e8f9a",
						sectionId: "b23f2668-c2dc-4213-88fe-eceedff46398",
						required: true,
						type: QuestionTypes.shortText,
						title: "Phone Number",
						description: "Your contact phone number",
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "e5f6a7b8-9c0d-1e2f-3a4b-5c6d7e8f9a0b",
						sectionId: "b23f2668-c2dc-4213-88fe-eceedff46398",
						required: true,
						type: QuestionTypes.date,
						title: "Date of Birth",
						description: "Select your date of birth",
						date: #{ hasYear: true, hasMonth: true, hasDay: true, minDate: utcDateTime.fromISO("1990-01-01T00:00:00Z"), maxDate: utcDateTime.fromISO("2010-12-31T23:59:59Z") },
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "f6a7b8c9-0d1e-2f3a-4b5c-6d7e8f9a0b1c",
						sectionId: "b23f2668-c2dc-4213-88fe-eceedff46398",
						required: true,
						type: QuestionTypes.longText,
						title: "Self Introduction",
						description: "Tell us about yourself (200-500 words)",
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					}
				],
			},
			#{
				id: "c34d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f",
				formId: "9a843aa0-8451-4e3b-b6a0-8c0e994e9040",
				title: "Academic & Experience",
				description: "Tell us about your academic background and experience",
				questions: #[
					#{
						id: "a7b8c9d0-1e2f-3a4b-5c6d-7e8f9a0b1c2d",
						sectionId: "c34d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f",
						required: true,
						type: QuestionTypes.dropdown,
						title: "Current Education Level",
						description: "Select your current education level",
						choices: #[
							#{ id: "ch1-1", name: "Freshman" },
							#{ id: "ch1-2", name: "Sophomore" },
							#{ id: "ch1-3", name: "Junior" },
							#{ id: "ch1-4", name: "Senior" },
							#{ id: "ch1-5", name: "Graduate Student" }
						],
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "b8c9d0e1-2f3a-4b5c-6d7e-8f9a0b1c2d3e",
						sectionId: "c34d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f",
						required: true,
						type: QuestionTypes.singleChoice,
						title: "Department/Major",
						description: "Select your department or major",
						choices: #[
							#{ id: "ch2-1", name: "Computer Science" },
							#{ id: "ch2-2", name: "Information Management" },
							#{ id: "ch2-3", name: "Electrical Engineering" },
							#{ id: "ch2-4", name: "Electronics Engineering" },
							#{ id: "ch2-5", name: "Other" }
						],
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "c9d0e1f2-3a4b-5c6d-7e8f-9a0b1c2d3e4f",
						sectionId: "c34d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f",
						required: true,
						type: QuestionTypes.date,
						title: "Expected Graduation Date",
						description: "When do you expect to graduate?",
						date: #{ hasYear: true, hasMonth: true, hasDay: false, minDate: utcDateTime.fromISO("2025-01-01T00:00:00Z"), maxDate: utcDateTime.fromISO("2030-12-31T23:59:59Z") },
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "d0e1f2a3-4b5c-6d7e-8f9a-0b1c2d3e4f5a",
						sectionId: "c34d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f",
						required: false,
						type: QuestionTypes.multipleChoice,
						title: "Previous Experience",
						description: "Select all that apply",
						choices: #[
							#{ id: "ch3-1", name: "Participated in hackathons" },
							#{ id: "ch3-2", name: "Open source contributor" },
							#{ id: "ch3-3", name: "Personal projects" },
							#{ id: "ch3-4", name: "Internship experience" },
							#{ id: "ch3-5", name: "Research assistant" },
							#{ id: "ch3-6", name: "None of the above" }
						],
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					}
				],
			},
			#{
				id: "d45e6f7a-8b9c-0d1e-2f3a-4b5c6d7e8f9a",
				formId: "9a843aa0-8451-4e3b-b6a0-8c0e994e9040",
				title: "Technical Skills",
				description: "Tell us about your technical expertise",
				questions: #[
					#{
						id: "e1f2a3b4-5c6d-7e8f-9a0b-1c2d3e4f5a6b",
						sectionId: "d45e6f7a-8b9c-0d1e-2f3a-4b5c6d7e8f9a",
						required: true,
						type: QuestionTypes.detailedMultipleChoice,
						title: "Programming Languages",
						description: "Select all programming languages you are familiar with",
						choices: #[
							#{ id: "ch4-1", name: "TypeScript/JavaScript", description: "Modern web development" },
							#{ id: "ch4-2", name: "Python", description: "General purpose and data science" },
							#{ id: "ch4-3", name: "Go", description: "Backend and systems programming" },
							#{ id: "ch4-4", name: "Rust", description: "Systems programming" },
							#{ id: "ch4-5", name: "C/C++", description: "Low-level programming" },
							#{ id: "ch4-6", name: "Java", description: "Enterprise applications" }
						],
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "f2a3b4c5-6d7e-8f9a-0b1c-2d3e4f5a6b7c",
						sectionId: "d45e6f7a-8b9c-0d1e-2f3a-4b5c6d7e8f9a",
						required: true,
						type: QuestionTypes.linearScale,
						title: "Backend Development Experience",
						description: "Rate your backend development experience level",
						scale: #{ minVal: 0, maxVal: 10, minValueLabel: "Beginner", maxValueLabel: "Expert" },
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "a3b4c5d6-7e8f-9a0b-1c2d-3e4f5a6b7c8d",
						sectionId: "d45e6f7a-8b9c-0d1e-2f3a-4b5c6d7e8f9a",
						required: true,
						type: QuestionTypes.linearScale,
						title: "Frontend Development Experience",
						description: "Rate your frontend development experience level",
						scale: #{ minVal: 0, maxVal: 10, minValueLabel: "Beginner", maxValueLabel: "Expert" },
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "b4c5d6e7-8f9a-0b1c-2d3e-4f5a6b7c8d9e",
						sectionId: "d45e6f7a-8b9c-0d1e-2f3a-4b5c6d7e8f9a",
						required: true,
						type: QuestionTypes.rating,
						title: "DevOps & Infrastructure",
						description: "Rate your familiarity with DevOps practices and infrastructure",
						scale: #{ icon: "star", minVal: 1, maxVal: 5, minValueLabel: "Novice", maxValueLabel: "Proficient" },
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "c5d6e7f8-9a0b-1c2d-3e4f-5a6b7c8d9e0f",
						sectionId: "d45e6f7a-8b9c-0d1e-2f3a-4b5c6d7e8f9a",
						required: false,
						type: QuestionTypes.multipleChoice,
						title: "Technologies You've Worked With",
						description: "Select all technologies you have experience with",
						choices: #[
							#{ id: "ch5-1", name: "Docker" },
							#{ id: "ch5-2", name: "Kubernetes" },
							#{ id: "ch5-3", name: "React/Vue/Angular" },
							#{ id: "ch5-4", name: "Node.js" },
							#{ id: "ch5-5", name: "PostgreSQL/MySQL" },
							#{ id: "ch5-6", name: "MongoDB" },
							#{ id: "ch5-7", name: "Redis" },
							#{ id: "ch5-8", name: "AWS/GCP/Azure" },
							#{ id: "ch5-9", name: "CI/CD (GitHub Actions, GitLab CI)" },
							#{ id: "ch5-10", name: "Git" }
						],
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					}
				],
			},
			#{
				id: "e56f7a8b-9c0d-1e2f-3a4b-5c6d7e8f9a0b",
				formId: "9a843aa0-8451-4e3b-b6a0-8c0e994e9040",
				title: "Team Preferences",
				description: "Help us understand your team preferences",
				questions: #[
					#{
						id: "d6e7f8a9-0b1c-2d3e-4f5a-6b7c8d9e0f1a",
						sectionId: "e56f7a8b-9c0d-1e2f-3a4b-5c6d7e8f9a0b",
						required: true,
						type: QuestionTypes.ranking,
						title: "Team Preferences",
						description: "Rank the following teams in order of your preference (1 = most preferred)",
						choices: #[
							#{ id: "team-1", name: "Core System Team", description: "Backend API & infrastructure development" },
							#{ id: "team-2", name: "Clustron Team", description: "Cluster management and distributed systems" },
							#{ id: "team-3", name: "HPC Team", description: "High-performance computing" },
							#{ id: "team-4", name: "Frontend Team", description: "User interface and experience" }
						],
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "e7f8a9b0-1c2d-3e4f-5a6b-7c8d9e0f1a2b",
						sectionId: "e56f7a8b-9c0d-1e2f-3a4b-5c6d7e8f9a0b",
						required: true,
						type: QuestionTypes.singleChoice,
						title: "Role Preference",
						description: "Which role are you most interested in?",
						choices: #[
							#{ id: "role-1", name: "Backend Developer" },
							#{ id: "role-2", name: "Frontend Developer" },
							#{ id: "role-3", name: "Full Stack Developer" },
							#{ id: "role-4", name: "DevOps Engineer" },
							#{ id: "role-5", name: "Data Engineer" },
							#{ id: "role-6", name: "System Administrator" }
						],
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "f8a9b0c1-2d3e-4f5a-6b7c-8d9e0f1a2b3c",
						sectionId: "e56f7a8b-9c0d-1e2f-3a4b-5c6d7e8f9a0b",
						required: true,
						type: QuestionTypes.longText,
						title: "Why SDC?",
						description: "Why do you want to join SDC? What are your expectations?",
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "a9b0c1d2-3e4f-5a6b-7c8d-9e0f1a2b3c4d",
						sectionId: "e56f7a8b-9c0d-1e2f-3a4b-5c6d7e8f9a0b",
						required: true,
						type: QuestionTypes.rating,
						title: "Team Collaboration",
						description: "How comfortable are you working in a team environment?",
						scale: #{ icon: "heart", minVal: 1, maxVal: 5, minValueLabel: "Prefer solo", maxValueLabel: "Love teamwork" },
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					}
				],
			},
			#{
				id: "f67a8b9c-0d1e-2f3a-4b5c-6d7e8f9a0b1c",
				formId: "9a843aa0-8451-4e3b-b6a0-8c0e994e9040",
				title: "Availability & Additional Information",
				description: "Final section - availability and additional materials",
				questions: #[
					#{
						id: "b0c1d2e3-4f5a-6b7c-8d9e-0f1a2b3c4d5e",
						sectionId: "f67a8b9c-0d1e-2f3a-4b5c-6d7e8f9a0b1c",
						required: true,
						type: QuestionTypes.multipleChoice,
						title: "Weekly Availability",
						description: "Which days are you available each week? (Select all that apply)",
						choices: #[
							#{ id: "day-1", name: "Monday" },
							#{ id: "day-2", name: "Tuesday" },
							#{ id: "day-3", name: "Wednesday" },
							#{ id: "day-4", name: "Thursday" },
							#{ id: "day-5", name: "Friday" },
							#{ id: "day-6", name: "Saturday" },
							#{ id: "day-7", name: "Sunday" }
						],
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "c1d2e3f4-5a6b-7c8d-9e0f-1a2b3c4d5e6f",
						sectionId: "f67a8b9c-0d1e-2f3a-4b5c-6d7e8f9a0b1c",
						required: true,
						type: QuestionTypes.linearScale,
						title: "Time Commitment",
						description: "How many hours per week can you commit to SDC activities?",
						scale: #{ minVal: 0, maxVal: 10, minValueLabel: "0-5 hours", maxValueLabel: "20+ hours" },
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "d2e3f4a5-6b7c-8d9e-0f1a-2b3c4d5e6f7a",
						sectionId: "f67a8b9c-0d1e-2f3a-4b5c-6d7e8f9a0b1c",
						required: true,
						type: QuestionTypes.uploadFile,
						title: "Resume/CV",
						description: "Please upload your resume or CV",
						uploadFile: #{ allowedFileTypes: #[allowedFileTypes.pdf, allowedFileTypes.doc, allowedFileTypes.docx], maxFileAmount: 1, maxFileSizeLimit: 5242880 },
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "e3f4a5b6-7c8d-9e0f-1a2b-3c4d5e6f7a8b",
						sectionId: "f67a8b9c-0d1e-2f3a-4b5c-6d7e8f9a0b1c",
						required: false,
						type: QuestionTypes.uploadFile,
						title: "Portfolio/Projects",
						description: "Upload any relevant portfolio materials or project documentation (optional)",
						uploadFile: #{ allowedFileTypes: #[allowedFileTypes.pdf, allowedFileTypes.zip], maxFileAmount: 3, maxFileSizeLimit: 10485760 },
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "f4a5b6c7-8d9e-0f1a-2b3c-4d5e6f7a8b9c",
						sectionId: "f67a8b9c-0d1e-2f3a-4b5c-6d7e8f9a0b1c",
						required: false,
						type: QuestionTypes.hyperlink,
						title: "GitHub Profile",
						description: "Link to your GitHub profile (if available)",
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "a5b6c7d8-9e0f-1a2b-3c4d-5e6f7a8b9c0d",
						sectionId: "f67a8b9c-0d1e-2f3a-4b5c-6d7e8f9a0b1c",
						required: false,
						type: QuestionTypes.hyperlink,
						title: "LinkedIn Profile",
						description: "Link to your LinkedIn profile (optional)",
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "b6c7d8e9-0f1a-2b3c-4d5e-6f7a8b9c0d1e",
						sectionId: "f67a8b9c-0d1e-2f3a-4b5c-6d7e8f9a0b1c",
						required: false,
						type: QuestionTypes.hyperlink,
						title: "Personal Website/Blog",
						description: "Link to your personal website or blog (if any)",
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					},
					#{
						id: "c7d8e9f0-1a2b-3c4d-5e6f-7a8b9c0d1e2f",
						sectionId: "f67a8b9c-0d1e-2f3a-4b5c-6d7e8f9a0b1c",
						required: false,
						type: QuestionTypes.longText,
						title: "Anything Else?",
						description: "Is there anything else you'd like us to know?",
						createdAt: utcDateTime.fromISO("2025-01-20T10:00:00Z"),
						updatedAt: utcDateTime.fromISO("2025-02-01T15:30:00Z"),
					}
				],
			}
		]
	})
	model ListSectionsResponse {
		sections: Section[];
	}

	// form recipientUser
	@doc("The basic info of a user that can receive the form.")
	@example(#{ id: "3c5fa073-7b97-43a3-bc44-ddc98f390a08", name: "John Doe" })
	model RecipientUser {
		id: uuid;
		name: string;
	}

	@doc("Select recipients by organizations and/or units.(remove duplicates).")
	@example(#{ unitIds: #["9a843aa0-8451-4e3b-b6a0-8c0e994e9040"] })
	model RecipientSelectionRequest {
		@doc("Target organization ID to collect users from.")
		orgId?: uuid;

		@doc("Target unit IDs to collect users from.")
		unitIds?: uuid[];
	}

	@doc("The result of recipients selection (no duplicated).")
	@example(#{ recipients: #[#{ id: "3c5fa073-7b97-43a3-bc44-ddc98f390a08", name: "John Doe" }] })
	model RecipientSelectionResponse {
		recipients: RecipientUser[];
	}

	@doc("Response after publishing a form.")
	@example(#{ visibility: FormVisibility.public })
	model FormPublishResponse {
		@doc("The visibility setting of the form. Public forms are visible to all logged-in users. Private forms require a direct link to access.")
		visibility: FormVisibility;
	}

	@doc("Response containing the Gmail address for Google Sheet permissions.")
	@example(#{ email: "core-system-bot@example.com" })
	model GoogleSheetEmailResponse {
		@doc("The Gmail address that should be added to Google Sheet permissions so the system can modify the form.")
		email: string;
	}

	@doc("Request body for verifying a Google Sheet URL.")
	@example(#{ googleSheetUrl: "https://docs.google.com/spreadsheets/d/1ABC123XYZ/edit" })
	model GoogleSheetVerifyRequest {
		@doc("The Google Sheet URL provided by user.")
		googleSheetUrl: string;
	}

	@doc("Verification result for the given Google Sheet URL.")
	@example(#{ isValid: true })
	model GoogleSheetVerifyResponse {
		@doc("Indicates whether the Google Sheet URL is valid and accessible.")
		isValid: boolean;
	}

	@doc("A font definition used in form dressing.")
	@example(#{ id: "LINESeedTW", name: "LINE Seed TW" })
	model Font {
		@doc("The unique identifier of the font.")
		id: string;

		@doc("The display name of the font.")
		name: string;
	}
}
