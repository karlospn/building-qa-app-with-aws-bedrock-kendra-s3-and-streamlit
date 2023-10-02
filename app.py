from langchain.retrievers import AmazonKendraRetriever
from langchain.llms.bedrock import Bedrock
from langchain.chains import RetrievalQA
from dotenv import load_dotenv
import streamlit as st
import os
import boto3

load_dotenv()

if os.getenv('KENDRA_INDEX') is None:
    st.error("KENDRA_INDEX not set. Please set this environment variable and restart the app.")
if os.getenv('AWS_BEDROCK_REGION') is None:
    st.error("AWS_BEDROCK_REGION not set. Please set this environment variable and restart the app.")
if os.getenv('AWS_KENDRA_REGION') is None:
    st.error("AWS_KENDRA_REGION not set. Please set this environment variable and restart the app.")

kendra_index = os.getenv('KENDRA_INDEX')
bedrock_region = os.getenv('AWS_BEDROCK_REGION')
kendra_region = os.getenv('AWS_KENDRA_REGION')

def get_kendra_doc_retriever():
    
    kendra_client = boto3.client("kendra", kendra_region)
    retriever = AmazonKendraRetriever(index_id=kendra_index, top_k=3, client=kendra_client, attribute_filter={
        'EqualsTo': {
            'Key': '_language_code',
            'Value': {'StringValue': 'en'}
        }
    }) 
    return retriever

st.title("AWS Q&A app 💎")

query = st.text_input("What would you like to know?")

max_tokens = st.number_input('Max Tokens', value=1000)
temperature= st.number_input(label="Temperature",step=.1,format="%.2f", value=0.7)
llm_model = st.selectbox("Select LLM model", ["Anthropic Claude V2", "Amazon Titan Text Express v1", "Ai21 Labs Jurassic-2 Ultra"])


if st.button("Search"):
    with st.spinner("Building response..."):
        if llm_model == 'Anthropic Claude V2':
            
            retriever = get_kendra_doc_retriever()  

            bedrock_client = boto3.client("bedrock-runtime", bedrock_region)
            llm = Bedrock(model_id="anthropic.claude-v2", region_name=bedrock_region, 
                        client=bedrock_client, 
                        model_kwargs={"max_tokens_to_sample": max_tokens, "temperature": temperature})

            qa = RetrievalQA.from_chain_type(llm=llm, chain_type="stuff", retriever=retriever)
            response = qa(query)
            st.markdown("### Answer:")
            st.write(response['result'])

        if llm_model == 'Amazon Titan Text Express v1':
            retriever = get_kendra_doc_retriever()       
            
            bedrock_client = boto3.client("bedrock-runtime", bedrock_region)
            llm = Bedrock(model_id="amazon.titan-text-express-v1", region_name=bedrock_region, 
                        client=bedrock_client, 
                        model_kwargs={"maxTokenCount": max_tokens, "temperature": temperature})

            qa = RetrievalQA.from_chain_type(llm=llm, chain_type="stuff", retriever=retriever)
            response = qa(query)
            st.markdown("### Answer:")
            st.write(response['result'])

        if llm_model == 'Ai21 Labs Jurassic-2 Ultra':
            
            retriever = get_kendra_doc_retriever()           
            
            bedrock_client = boto3.client("bedrock-runtime", bedrock_region)
            llm = Bedrock(model_id="ai21.j2-ultra-v1", region_name=bedrock_region, 
                        client=bedrock_client, 
                        model_kwargs={"maxTokens": max_tokens, "temperature": temperature})

            qa = RetrievalQA.from_chain_type(llm=llm, chain_type="stuff", retriever=retriever)
            response = qa(query)
            st.markdown("### Answer:")
            st.write(response['result'])
