import sqlite3
from typing import Optional, Tuple

import matplotlib.pyplot as plt
import pandas as pd


def plot_temoa_production_pathways(
    sqlite_path: str,
    demand_comm: str = "CEM",
    emission_comm: str = "co2_cem",
    cap_region: Optional[str] = None,
    scenario_name: Optional[str] = None,
    figsize: Tuple[float, float] = (10, 4.5),
    title_fontsize: int = 14,
    label_fontsize: int = 13,
    tick_fontsize: int = 12,
    legend_fontsize: int = 11,
    save_path: Optional[str] = None,
):
    """
    Query Temoa results from a SQLite database and plot:
    - Left: stacked production by technology
    - Right: co2_cem emissions and co2_cem cap

    Parameters
    ----------
    sqlite_path : str
        Path to the Temoa SQLite result database.
    demand_comm : str
        Demand commodity used for filtering production and demand.
    emission_comm : str
        Emission commodity name, e.g. "co2_cem".
    cap_region : str | None
        Region name used in limit_emission for cap query.
        If None, aggregate cap across all regions.
    figsize : tuple
        Figure size for matplotlib.
    save_path : str | None
        If provided, save figure to this path.

    Returns
    -------
    (fig, axes, df_tech, df_co2, df_cap)
    """
    con = sqlite3.connect(sqlite_path)
    try:
        # Check available tables for compatibility across Temoa outputs.
        tbls = set(
            pd.read_sql_query(
                "SELECT name FROM sqlite_master WHERE type='table'", con
            )["name"].tolist()
        )
        if "output_flow_out" not in tbls:
            raise ValueError(
                "Table 'output_flow_out' not found in this sqlite. "
                "Please pass a solved Temoa result database."
            )
        if "output_emission" not in tbls:
            raise ValueError(
                "Table 'output_emission' not found in this sqlite. "
                "Please pass a solved Temoa result database."
            )

        q_tech = f"""
        SELECT period, tech, SUM(flow) AS prod_mt
        FROM output_flow_out
        WHERE output_comm = '{demand_comm}'
        GROUP BY period, tech
        ORDER BY period
        """
        df_tech_raw = pd.read_sql_query(q_tech, con)

        q_co2 = f"""
        SELECT period, SUM(emission) AS co2_cem_mt
        FROM output_emission
        WHERE emis_comm = '{emission_comm}'
        GROUP BY period
        ORDER BY period
        """
        df_co2 = pd.read_sql_query(q_co2, con)

        if "limit_emission" in tbls:
            if cap_region:
                q_cap = f"""
                SELECT period, SUM(value) AS co2_cem_cap_mt
                FROM limit_emission
                WHERE region = '{cap_region}'
                  AND emis_comm = '{emission_comm}'
                GROUP BY period
                ORDER BY period
                """
            else:
                q_cap = f"""
                SELECT period, SUM(value) AS co2_cem_cap_mt
                FROM limit_emission
                WHERE emis_comm = '{emission_comm}'
                GROUP BY period
                ORDER BY period
                """
            df_cap = pd.read_sql_query(q_cap, con)
        else:
            df_cap = pd.DataFrame(columns=["period", "co2_cem_cap_mt"])
    finally:
        con.close()

    if not df_tech_raw.empty:
        df_tech = (
            df_tech_raw.pivot(index="period", columns="tech", values="prod_mt")
            .fillna(0.0)
            .sort_index()
        )
    else:
        df_tech = pd.DataFrame()

    fig, axes = plt.subplots(1, 2, figsize=figsize)

    # Left: stacked production by technology
    if not df_tech.empty:
        # Keep a stable bottom-to-top order for CEM pathways.
        preferred_order = ["CEM_PROD", "CEM_PROD_RETRO", "CEM_PROD_CCS"]
        ordered_cols = [c for c in preferred_order if c in df_tech.columns] + [
            c for c in df_tech.columns if c not in preferred_order
        ]
        df_tech = df_tech[ordered_cols]

        axes[0].stackplot(
            df_tech.index.values,
            [df_tech[c].values for c in df_tech.columns],
            labels=[str(c) for c in df_tech.columns],
        )
        axes[0].legend(loc="upper left", fontsize=legend_fontsize)
    axes[0].set_title("Production by Technology")
    axes[0].set_xlabel("Period")
    axes[0].set_ylabel("Production (Mt)")
    axes[0].set_ylim(0, 15)
    axes[0].grid(axis="y", alpha=0.3)
    axes[0].tick_params(axis="both", labelsize=tick_fontsize)

    # Right: only co2_cem emissions and cap
    if not df_co2.empty:
        axes[1].plot(
            df_co2["period"],
            df_co2["co2_cem_mt"],
            marker="s",
            label=f"{emission_comm} emissions (Mt)",
        )
    if not df_cap.empty:
        axes[1].plot(
            df_cap["period"],
            df_cap["co2_cem_cap_mt"],
            marker="^",
            linestyle="--",
            label=f"{emission_comm} cap (Mt)",
        )
    axes[1].set_title(f"{emission_comm} Pathway")
    axes[1].set_xlabel("Period")
    axes[1].set_ylabel("Mt")
    axes[1].set_ylim(0, 2.3)
    axes[1].grid(alpha=0.3)
    axes[1].legend(fontsize=legend_fontsize)
    axes[1].tick_params(axis="both", labelsize=tick_fontsize)

    # Use consistent decade ticks from 2020 to 2060.
    xticks = list(range(2020, 2061, 10))
    for ax in axes:
        ax.set_xticks(xticks)
        ax.set_xlim(2020, 2060)
        ax.title.set_fontsize(title_fontsize)
        ax.xaxis.label.set_fontsize(label_fontsize)
        ax.yaxis.label.set_fontsize(label_fontsize)

    if scenario_name:
        fig.suptitle(f"Scenario: {scenario_name}", fontsize=title_fontsize + 1, y=1.03)

    plt.tight_layout()
    if save_path:
        fig.savefig(save_path, dpi=300, bbox_inches="tight")

    return fig, axes, df_tech, df_co2, df_cap


def plot_temoa_cement_cost_comparison(
    scenario_sqlite_map: dict,
    demand_comm: str = "CEM",
    sector_name: str = "industrial",
    cement_techs: Tuple[str, ...] = ("CEM_PROD", "CEM_PROD_RETRO", "CEM_PROD_CCS"),
    figsize: Tuple[float, float] = (12, 4.5),
    title_fontsize: int = 14,
    label_fontsize: int = 13,
    tick_fontsize: int = 12,
    legend_fontsize: int = 11,
    save_path: Optional[str] = None,
):
    """
    Plot two cost comparison charts for multiple scenarios:
    - Left: total cement production cost by period (M$)
    - Right: unit cement production cost by period (M$/Mt)

    Parameters
    ----------
    scenario_sqlite_map : dict
        Mapping {scenario_label: sqlite_path}.
    demand_comm : str
        Demand commodity, default "CEM".
    """
    rows = []
    tech_list_sql = ", ".join([f"'{t}'" for t in cement_techs])
    for scen, sqlite_path in scenario_sqlite_map.items():
        con = sqlite3.connect(sqlite_path)
        try:
            q_cost = f"""
            SELECT period,
                   SUM(invest + fixed + var + emiss) AS total_cost_musd
            FROM output_cost
            WHERE sector = ?
              AND tech IN ({tech_list_sql})
            GROUP BY period
            ORDER BY period
            """
            df_cost = pd.read_sql_query(q_cost, con, params=[sector_name])

            q_prod = f"""
            SELECT period, SUM(flow) AS cement_prod_mt
            FROM output_flow_out
            WHERE output_comm = '{demand_comm}'
              AND sector = ?
              AND tech IN ({tech_list_sql})
            GROUP BY period
            ORDER BY period
            """
            df_prod = pd.read_sql_query(q_prod, con, params=[sector_name])
        finally:
            con.close()

        df = pd.merge(df_cost, df_prod, on="period", how="inner")
        df["scenario"] = scen
        # Unit: M$/Mt
        df["unit_cost_musd_per_mt"] = df["total_cost_musd"] / df["cement_prod_mt"]
        rows.append(df)

    df_all = pd.concat(rows, ignore_index=True)

    fig, axes = plt.subplots(1, 2, figsize=figsize)
    scenarios = list(scenario_sqlite_map.keys())

    for scen in scenarios:
        d = df_all[df_all["scenario"] == scen].sort_values("period")
        axes[0].plot(d["period"], d["total_cost_musd"], marker="o", linewidth=2, label=scen)
        axes[1].plot(
            d["period"],
            d["unit_cost_musd_per_mt"],
            marker="o",
            linewidth=2,
            label=scen,
        )

    axes[0].set_title("Total Cement Production Cost")
    axes[0].set_xlabel("Period")
    axes[0].set_ylabel("M$")
    axes[0].grid(alpha=0.3)
    axes[0].legend(fontsize=legend_fontsize)

    axes[1].set_title("Unit Cement Production Cost")
    axes[1].set_xlabel("Period")
    axes[1].set_ylabel("M$/Mt")
    axes[1].grid(alpha=0.3)
    axes[1].legend(fontsize=legend_fontsize)

    xticks = list(range(2020, 2061, 10))
    for ax in axes:
        ax.set_xticks(xticks)
        ax.set_xlim(2020, 2060)
        ax.tick_params(axis="both", labelsize=tick_fontsize)
        ax.title.set_fontsize(title_fontsize)
        ax.xaxis.label.set_fontsize(label_fontsize)
        ax.yaxis.label.set_fontsize(label_fontsize)

    plt.tight_layout()
    if save_path:
        fig.savefig(save_path, dpi=300, bbox_inches="tight")

    return fig, axes, df_all
