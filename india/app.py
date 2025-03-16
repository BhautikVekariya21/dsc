import streamlit as st 
import numpy as np
import pandas as pd
import plotly.express as px

st.set_page_config(layout="wide", page_title="India's Analysis")

df = pd.read_csv(r'C:\Users\bhaut\OneDrive\Desktop\dsc\india\cleaned_data.csv')

list_of_states = df['State'].unique().tolist()
list_of_states.insert(0, 'Overall India')
list_of_states.sort()

st.sidebar.title('India Analysis')

selected_state = st.sidebar.selectbox('Select a State', list_of_states)
primary = st.sidebar.selectbox('Select Primary Parameter', sorted(df.columns[11:]))
secondary = st.sidebar.selectbox('Select Secondary Parameter', sorted(df.columns[11:]))
plot = st.sidebar.button('Plot Graph')

if plot:
    st.text('Size represents primary parameter')
    st.text('Color represents secondary parameter')
    if selected_state == 'Overall India':
        # Filter the DataFrame for overall India
        df_filtered = df
    else:
        # Filter the DataFrame for the selected state
        df_filtered = df[df['State'] == selected_state]

    # Plotting with reduced dot size
    fig = px.scatter_mapbox(df_filtered,
                            lat="Latitude",
                            lon="Longitude",
                            size=primary,
                            color=secondary,
                            size_max=10,  # Reduced dot size here
                            zoom=4,
                            mapbox_style="carto-positron",
                            width=1200,
                            height=700,
                            hover_name="District")

    st.plotly_chart(fig, use_container_width=True)
