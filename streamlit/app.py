import streamlit as st
import pandas as pd
import plotly.graph_objects as go

st.set_page_config(layout="wide", page_title="Startup Analysis")
# Load Data
df = pd.read_csv(r'C:\Users\bhaut\OneDrive\Desktop\dsc\streamlit\startup_cleaned.csv')
df['date'] = pd.to_datetime(df['date'], errors='coerce')
df['year'] = df['date'].dt.year
df['month'] = df['date'].dt.month

def overall_analysis():
    total = round(df['amount'].sum())
    max_funded = df.groupby('startup')['amount'].max().sort_values(ascending=False).head(1).values[0]
    avg_funded = df.groupby('startup')['amount'].sum().mean()
    num_startups = df['startup'].nunique()

    col1, col2, col3, col4 = st.columns(4)
    with col1: st.metric('Total', f'{total} M$')
    with col2: st.metric('Max', f'{max_funded} M$')
    with col3: st.metric('Avg', f'{round(avg_funded)} M$')
    with col4: st.metric('Funded Startups', num_startups)

    st.header('Monthly Investment Trends')
    
    # Total Investments
    investments_df = df.groupby(['year', 'month'])['startup'].count().reset_index()
    investments_df['x_axis'] = investments_df['month'].astype(str) + '-' + investments_df['year'].astype(str)
    fig1 = go.Figure(go.Scatter(x=investments_df['x_axis'], y=investments_df['startup'], mode='lines+markers'))
    fig1.update_layout(title="Number of Deals", height=400, width=1200)
    st.plotly_chart(fig1)
    
    # Total Amount
    amount_df = df.groupby(['year', 'month'])['amount'].sum().reset_index()
    amount_df['x_axis'] = amount_df['month'].astype(str) + '-' + amount_df['year'].astype(str)
    fig2 = go.Figure(go.Scatter(x=amount_df['x_axis'], y=amount_df['amount'], mode='lines+markers', line=dict(color='green')))
    fig2.update_layout(title="Investment Amount", height=400, width=1200)
    st.plotly_chart(fig2)
def load_startup_details(startup_name):
    st.title(f"Details of {startup_name}")
    
    # Filter Data for the selected startup
    startup_data = df[df['startup'] == startup_name].iloc[0]
    
    # Basic Info
    col1, col2, col3 = st.columns(3)
    with col1:
        st.subheader("Industry")
        st.markdown(f"**Vertical:** {startup_data['vertical']}")
        st.markdown(f"**Sub-Vertical:** {startup_data['Sub Vertical']}")
    with col2:
        st.subheader("Location")
        st.markdown(f"**City:** {startup_data['city']}")
        st.markdown(f"**Founded:** {startup_data['date'].year if pd.notnull(startup_data['date']) else 'N/A'}")
    with col3:
        st.subheader("Funding Info")
        st.markdown(f"**Total Funding:** {round(df[df['startup'] == startup_name]['amount'].sum())} M$")
        st.markdown(f"**Latest Round:** {startup_data['round']}")

    # Funding History
    st.subheader("Funding Rounds")
    funding_df = df[df['startup'] == startup_name][['date', 'round', 'investors', 'amount']]
    funding_df['date'] = funding_df['date'].dt.strftime('%Y-%m-%d')
    st.dataframe(funding_df.style.format({'amount': '{:.1f} M$'}), height=200)

    # Similar Startups
    st.subheader("Similar Companies")
    similar_df = df[ 
        (df['vertical'] == startup_data['vertical']) | 
        (df['Sub Vertical'] == startup_data['Sub Vertical'])
    ].query("startup != @startup_name")
    
    if not similar_df.empty:
        cols = ['startup', 'vertical', 'Sub Vertical', 'city', 'amount']
        st.dataframe(
            similar_df[cols].groupby('startup').first().reset_index(),
            column_config={
                "amount": st.column_config.NumberColumn(
                    "Total Raised",
                    format="$ %.1f M",
                )
            }
        )
    else:
        st.write("No similar companies found")

def load_investor_details(investor):
    st.title(investor)
    
    # Recent Investments
    last5_df = df[df['investors'].str.contains(investor, na=False)].head()[['date', 'startup', 'vertical', 'city', 'round', 'amount']]
    st.subheader('Most Recent Investments')
    st.dataframe(last5_df)
    
    # First Column (Biggest Investments)
    col1, col2 = st.columns(2)
    
    with col1:
        big_df = df[df['investors'].str.contains(investor)].groupby('startup')['amount'].sum().sort_values(ascending=False).head()
        st.subheader('Biggest Investments')
        
        # Plot using Plotly
        fig = go.Figure([go.Bar(x=big_df.index, y=big_df.values)])
        fig.update_layout(
            title="Biggest Investments",
            xaxis_title="Startup",
            yaxis_title="Investment Amount",
            height=600,  # Control height and width here
            width=800
        )
        st.plotly_chart(fig)
        
    with col2:
        vertical_df = df[df['investors'].str.contains(investor)].groupby('vertical')['amount'].sum()
        st.subheader('Sectors Invested In')
        
        # Plot using Plotly
        fig1 = go.Figure([go.Pie(labels=vertical_df.index, values=vertical_df.values, hole=0.3)])
        fig1.update_layout(
            title="Sectors Invested In",
            height=600,  # Control height
            width=800
        )
        st.plotly_chart(fig1)

    # Second Column (Investment Rounds & Cities Invested)
    col3, col4 = st.columns(2)
    
    with col3:
        round_df = df[df['investors'].str.contains(investor)].groupby('round')['amount'].sum()
        st.subheader('Investment Rounds')
        
        # Plot using Plotly
        fig2 = go.Figure([go.Pie(labels=round_df.index, values=round_df.values, hole=0.3)])
        fig2.update_layout(
            title="Investment Rounds",
            height=600,  # Control height
            width=800
        )
        st.plotly_chart(fig2)
        
    with col4:
        city_df = df[df['investors'].str.contains(investor)].groupby('city')['amount'].sum()
        st.subheader('Cities Invested In')
        
        # Plot using Plotly
        fig3 = go.Figure([go.Pie(labels=city_df.index, values=city_df.values, hole=0.3)])
        fig3.update_layout(
            title="Cities Invested In",
            height=600,  # Control height
            width=800
        )
        st.plotly_chart(fig3)

    # Third Column (Yearly Investments)
    col5, col6 = st.columns(2)
    
    with col5:
        year_df = df[df['investors'].str.contains(investor)].groupby('year')['amount'].sum()
        st.subheader('Yearly Investments')

        # Plot using Plotly (Line Chart)
        fig4 = go.Figure([go.Scatter(x=year_df.index, y=year_df.values, mode='lines+markers')])
        fig4.update_layout(
            title="Yearly Investments",
            xaxis_title="Year",
            yaxis_title="Investment Amount",
            height=600,  # Control height
            width=800
        )
        st.plotly_chart(fig4)
        
    with col6:
        # Similar Investors Based on Total Investments (Top 5 Investors)
        st.subheader('Top 5 Investors Based on Total Investment')
        
        # Grouping by investor and summing the total investment amount
        investor_df = df.groupby('investors')['amount'].sum().reset_index()
        
        # Sort by investment amount and take the top 5 investors
        top_investors = investor_df.sort_values(by='amount', ascending=False).head(5)
        
        # Plot using Plotly (Bar Chart)
        fig5 = go.Figure([go.Bar(x=top_investors['investors'], y=top_investors['amount'])])
        fig5.update_layout(
            title="Top 5 Investors by Total Investment",
            xaxis_title="Investor",
            yaxis_title="Investment Amount",
            height=600,  # Control height
            width=800
        )
        st.plotly_chart(fig5)

# Sidebar options
st.sidebar.title('Startup Funding Analysis')
option = st.sidebar.selectbox('Select One', ['Overall Analysis', 'Startup', 'Investor'])

if option == 'Overall Analysis':
    st.title('Overall Analysis')
    btn0 = st.sidebar.button('Show Overall Analysis')
    if btn0:
        overall_analysis()
elif option == 'Startup':
    selected_startup = st.sidebar.selectbox('Select Startup', sorted(df['startup'].unique().tolist()))
    btn1 = st.sidebar.button('Find Startup Details')
    if btn1:  # Trigger startup details on button click
        load_startup_details(selected_startup)
else:
    selected_investor = st.sidebar.selectbox('Select Investor', sorted(set(df['investors'].str.split(',').sum())))
    btn2 = st.sidebar.button('Find Investor Details')
    if btn2:
        load_investor_details(selected_investor)
