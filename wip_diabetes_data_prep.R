#' Revise 10k diabetes for learning in Vienna class
#' TK
#' May 30, 2024
library(httr)
library(jsonlite)
library(uuid)

df <- read.csv('https://raw.githubusercontent.com/kwartler/teaching-datasets/main/10k_diabetes.csv')
df$id <- UUIDgenerate(n=nrow(df))

allNotes <- paste(df$diag_1_desc, df$diag_1,
                  df$diag_2_desc, df$diag_2,
                  df$diag_3_desc, df$diag_3, sep = ',')

# Master level notes for DTM creation
drNotes <- data.frame(id = df$id, drNotes = allNotes)

df$diag_1_desc <- NULL
df$diag_2_desc <- NULL
df$diag_3_desc <- NULL

df$diag_1 <- NULL
df$diag_2 <- NULL
df$diag_3 <- NULL

# First Table
patientDemographics <- data.frame(df$id, 
                                  df$race,
                                  df$gender,
                                  df$age,
                                  df$weight)

df$race<- NULL
df$gender<- NULL
df$age<- NULL
df$weight<- NULL

# Second Table
hospitalStayData <- data.frame(df$id, 
                               df$admission_type_id,
                               df$discharge_disposition_id,
                               df$admission_source_id,
                               df$time_in_hospital,
                               df$payer_code,
                               df$medical_specialty,
                               df$num_lab_procedures,
                               df$num_procedures,
                               df$num_medications,
                               df$number_outpatient,
                               df$number_emergency,
                               df$number_inpatient,
                               df$number_diagnoses,
                               df$readmitted)

df$admission_type_id<- NULL
df$discharge_disposition_id<- NULL
df$admission_source_id<- NULL
df$time_in_hospital<- NULL
df$payer_code<- NULL
df$medical_specialty<- NULL
df$num_lab_procedures<- NULL
df$num_procedures<- NULL
df$num_medications<- NULL
df$number_outpatient<- NULL
df$number_emergency<- NULL
df$number_inpatient<- NULL
df$number_diagnoses<- NULL
df$readmitted <- NULL

# Drug data
drugData <- data.frame(id = df$id,
                       df[,c(1:27)])


# Master level tables
drNotes
patientDemographics
hospitalStayData
drugData

names(drNotes)
names(patientDemographics) <- gsub('df.','',names(patientDemographics))
names(hospitalStayData)<- gsub('df.','',names(hospitalStayData))
names(drugData)

write.csv(drNotes,'~/Desktop/teaching-datasets/diabetes_tables/drNotes.csv', row.names = F)
write.csv(patientDemographics,'~/Desktop/teaching-datasets/diabetes_tables/patientDemographics.csv', row.names = F)
write.csv(hospitalStayData,'~/Desktop/teaching-datasets/diabetes_tables/hospitalStayData.csv', row.names = F)
write.csv(drugData,'~/Desktop/teaching-datasets/diabetes_tables/drugData.csv', row.names = F)


allPatientData <- dplyr::left_join(patientDemographics, drugData,
                                   by = join_by(id))

allPatientData <- dplyr::left_join(allPatientData, hospitalStayData,
                                   by = join_by(id))

allPatientData <- dplyr::left_join(allPatientData, drNotes,
                                   by = join_by(id))


### NEXT TIME CREATE ACTUAL NOTES - this would take 36hrs.


# Make fake doctor notes
# Inputs
llmModel <- 'lmstudio-community/Meta-Llama-3-8B-Instruct-GGUF'#'lmstudio-ai/gemma-2b-it-GGUF'
headers <- c(`Content-Type` = "application/json")

allNotesList <- list()
for(i in 1:length(allNotes)){
  print(i)
  # Organize Request
  dataLLM <- list(model = llmModel,
                  messages = list(
                    list(role = "system", content = "You are a synthetic data generator helping to create fake doctor notes for diabetes hospitalized patients. You always write one paragraph of text based on the diagnosis codes and descriptions below.  You are free to make up patient names, doctor names, hostpital institutions in your one paragraph.You MUST include the original input below within the paragraph.  PLease return the paragraph without any addition context such as 'Here is a fake doctor's note:' or 'Sure, here is your fake doctor's note'.\n\nHere is an example returned:\n\n```This is to certify that I have examined Jane Doe, a patient at Mercy General Hospital, and have determined that she requires hospitalization for treatment of her medical condition. On admission, Ms. Doe was experiencing severe spinal stenosis in the cervical region, which necessitated immediate attention to prevent further complications. Additionally, an effusion of the joint, site unspecified, was observed, requiring prompt intervention. I have ordered a comprehensive course of treatment including physical therapy, pain management, and medication administration to alleviate her symptoms and facilitate a full recovery. - John Smith, MD```"),
                    list(role = "user", content = allNotes[i])),
                  temperature = 0.7,
                  max_tokens = 128,#512,
                  stream = FALSE)
  
  # Make the POST request
  res <- httr::POST(url = "http://localhost:1234/v1/chat/completions",
                    httr::add_headers(.headers = headers),
                    body = toJSON(dataLLM, auto_unbox = TRUE))
  
  # Extract the response
  llmResponse <- httr::content(res)$choices[[1]]$message$content
  allNotesList[[i]] <- llmResponse
  #cat(llmResponse)
  
}
