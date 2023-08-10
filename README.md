# **Introduction**

This repository contains a practical example about how to build a Q&A app (powered by a LLM model) capable of answering questions related to your private documents in just a couple of hours.

> Previously, I built a Q&A app using Azure OpenAI GPT-4 and Pinecone _(you can find it in [here](https://github.com/karlospn/building-qa-app-with-openai-pinecone-and-streamlit))_.   
> In this repository I will built exactly the same app but using only AWS services (+ Streamlit for the UI).

To be more precise, the app has the following architecture:

![aws-architecture-diagram](https://raw.githubusercontent.com/karlospn/building-qa-app-with-aws-bedrock-kendra-s3-and-streamlit/main/docs/aws-architecture-diagram.png)

It uses the following technologies:

- [AWS Bedrock](https://aws.amazon.com/bedrock)
- [AWS Kendra](https://aws.amazon.com/kendra)
- [AWS S3](https://aws.amazon.com/s3)
- [Streamlit](https://streamlit.io/)

# **Content**

This repository contains the following application:
- A ``Streamlit`` app,  which allow us to query the data stored in AWS Kendra using one of the available AWS Bedrock LLM models.

![app-diagram](https://raw.githubusercontent.com/karlospn/building-qa-app-with-aws-bedrock-kendra-s3-and-streamlit/main/docs/app-interaction-diagram.png)

# **Jupyter notebooks**

- If instead of using the ``Streamlit`` app, you prefer to execute step by step the instructions for setting up the RAG pattern, you have a Jupyter notebook (``/notebooks/rag-with-langchain.ipynb``) that will precisely allow you to do this.

- The ``Streamlit`` app makes heavy use of the ``LangChain`` library to implement the RAG pattern. If you prefer not to use any third-party libraries and set up the RAG pattern solely with the ``boto3`` library, you have a second Jupyter notebook (``/notebooks/rag-with-only-boto3.ipynb``) that will allow you to do this.

# **AWS Infrastructure**

In the ``/infra`` folder, you'll find a series of Terraform files that will create every AWS services required for the proper functioning of the app.

These Terraform files will create the following resources:
- An s3 bucket for housing our private docs.
- A Kendra index with an s3 connector.
- An IAM role with the required permissions to make everything work.


# **Prerequisites**

There are a few prerequisites that you should be aware of before attempting to run the application.

## **AWS Bedrock**
- As of today (08/09/2023), AWS Bedrock is still on preview. To access it, you'll need to sign up for the preview.

![preview](https://raw.githubusercontent.com/karlospn/building-qa-app-with-aws-bedrock-kendra-s3-and-streamlit/main/docs/rag-aws-bedrock-preview.png)

- Once admitted to the preview, you will have access only to the Amazon Titan LLM. To utilize any of the third-party LLMs (Anthropic and AI21 Labs LLM models), you must register for access separately.

To use this application, you must have access to both components. 

## **boto3 credentials**

- Within the app, ``boto3`` retrieves the AWS credentials from the ``default`` profile of the AWS config file. Feel free to adjust this configuration to align it with your preferences, whether that involves utilizing environment variables, passing credentials as parameters, or employing other suitable methods.

For an overview of the multiples approaches for configuring ``boto3`` credentials, go to the following link:
- https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html

# **How to run the app**

> Before trying to run the app, read the _AWS Infrastructure_ and the _Prerequisites_ section.

## **Run the app locally**

### **Set the required environment variables**

The repository has a ``.env`` file that contains the environment variables that the app requires to run successfully:

```text
KENDRA_INDEX='<kendra-index>'
AWS_BEDROCK_REGION='<bedrock-region>'
AWS_KENDRA_REGION='<region-where-kendra-index-is-deployed>'
```
Change the values accordingly.

### **Restore dependencies**

```bash
pip install -r requirements.txt
```
### **Run the app**

When you install ``Streamlit``, a command-line (CLI) tool gets installed as well. The purpose of this tool is to run ``Streamlit`` apps.   
To execute the app, just run the following command:
```bash
streamlit run app.py
```

## **Run the app using Docker**

> This repository has a ``Dockerfile`` in case you prefer to execute the app on a container.

### **Build the image**

```shell
docker build -t aws-rag-app .
```

### **Run it**

```
docker run -p 5050:5050 \
        -e KENDRA_INDEX="<kendra-index>" \
        -e AWS_BEDROCK_REGION="<bedrock-region>" \
        -e AWS_KENDRA_REGION="<region-where-kendra-index-is-deploy>" \
        -e AWS_ACCESS_KEY_ID="<aws-access-key>" \
        -e AWS_SECRET_ACCESS_KEY="<aws-secret-access-key>" \
        aws-rag-app
```

# **Output**

![output](https://raw.githubusercontent.com/karlospn/building-qa-app-with-aws-bedrock-kendra-s3-and-streamlit/main/docs/rag-aws-output-1.png)
