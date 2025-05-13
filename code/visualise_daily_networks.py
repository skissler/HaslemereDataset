import pandas as pd
import networkx as nx
import matplotlib.pyplot as plt
from matplotlib.cm import ScalarMappable
from matplotlib.colors import Normalize
import os

# Create output directory
output_dir = "figures"
os.makedirs(output_dir, exist_ok=True)

# Load data
contacts = pd.read_csv("data/HaslemereProximity.csv")
timeconversion = pd.read_csv("data/TimeConversion.csv")

# Add 'day' column to timeconversion
timeconversion['day'] = timeconversion['timestamp'].str[:3]

# Merge day into contacts
contacts = contacts.merge(
    timeconversion[['time_step', 'day']],
    on='time_step',
    how='left'
)

# Summarize contacts under 10 meters
contacts_summary = (
    contacts[contacts['distance_m'] < 10]
    .groupby(['user1_id', 'user2_id', 'day'])
    .size()
    .reset_index(name='duration')
)

# Order days
day_order = ['Thu', 'Fri', 'Sat']
contacts_summary['day'] = pd.Categorical(contacts_summary['day'], categories=day_order, ordered=True)
contacts_summary = contacts_summary.sort_values(['day', 'user1_id', 'user2_id'])

# Compute hours in contact
contacts_summary['Hours in contact'] = contacts_summary['duration'] / 12

# Plot each graph and save as PDF
for day in day_order:
    data = contacts_summary[contacts_summary['day'] == day]

    # Build graph
    G = nx.Graph()
    G.add_edges_from(zip(data['user1_id'], data['user2_id']))

    # Use circular layout
    pos = nx.circular_layout(G)

    # Create figure
    fig, ax = plt.subplots(figsize=(6, 6))
    ax.set_title(f"Day: {day}")
    ax.set_axis_off()

    # Draw edges with transparency based on hours in contact
    edges = list(zip(data['user1_id'], data['user2_id']))
    alphas = data['Hours in contact'] / 24  # normalize to [0, 1]

    for (u, v), alpha in zip(edges, alphas):
        nx.draw_networkx_edges(G, pos, edgelist=[(u, v)], alpha=alpha, edge_color='black', ax=ax)

    # Draw nodes
    nx.draw_networkx_nodes(G, pos, node_size=10, ax=ax, node_color="black")

    # Add colorbar as alpha proxy
    norm = Normalize(vmin=0, vmax=24)
    sm = ScalarMappable(norm=norm, cmap='Greys')
    sm.set_array([])
    cbar = fig.colorbar(sm, ax=ax, orientation='horizontal', pad=0.05, fraction=0.05)
    cbar.set_label('Hours in contact')

    # Save to PDF
    output_path = os.path.join(output_dir, f"{day}_network_py.pdf")
    plt.savefig(output_path, format='pdf', bbox_inches='tight')
    plt.close(fig)
