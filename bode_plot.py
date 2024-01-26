# -*- coding: utf-8 -*-
"""
Created on Thu Jan 25 21:11:31 2024

@author: Ke
"""
import numpy as np
import matplotlib.pyplot as plt
import control

theta = [1.4, 2.0, 1.4, 1.5]

# Numerator and denominator coefficients for the transfer functions
# Coefficients are written as (coefficient, delay) tuples for terms with delays
num_coeffs = [
    [(0.294, theta[0]), (0.074, theta[0])], 
    [(0.409, theta[1]), (0.088, theta[1])], 
    [(0.578, theta[2]), (0.030, theta[2])], 
    [(0.443, theta[3]), (0.015, theta[3])]
]
den_coeffs = [
    [1, (0.352, theta[0]), (0.074, theta[0])], 
    [1, (0.479, theta[1]), (0.088, theta[1])], 
    [1, (0.587, theta[2]), (0.030, theta[2])], 
    [1, (0.436, theta[3]), (0.015, theta[3])]
]

# Define different line styles for each transfer function
line_styles = ['-', '--', '-.', ':']

# Create a Bode plot for each transfer function
plt.figure(figsize=(14, 8))

# Define the frequency range for the Bode plot
w = np.logspace(-2, 1, 100)

H_s = []

for i in range(4):
    # Pade approximation of delay for each term
    num_pade, den_pade = control.pade(theta[i], 10)  # Using a 10th-order approximation
    delay_tf = control.TransferFunction(num_pade, den_pade)
    
    # Create the transfer function without delay
    num = [num_coeffs[i][0][0], num_coeffs[i][1][0]]
    den = [1, den_coeffs[i][1][0], den_coeffs[i][2][0]]

    # Create the transfer function for non-delayed terms
    tf = control.TransferFunction(num, den)
    
    # Combine the non-delayed transfer function with the delayed one
    H = tf * delay_tf
    H_s.append(H)

# Plotting
plt.figure(figsize=(14, 8))
for i, H in enumerate(H_s):
    # Calculate the frequency response
    mag, phase, omega = control.bode_plot(H, w, Plot=False)
    
    # Plot magnitude
    plt.subplot(2, 1, 1)
    plt.semilogx(omega, 20*np.log10(mag), line_styles[i], linewidth=3.5, label=f'H{i+1}(s)')
    
    # Plot phase
    plt.subplot(2, 1, 2)
    plt.semilogx(omega, np.degrees(phase), line_styles[i], linewidth=3.5, label=f'H{i+1}(s)')

# Set the titles and labels for the magnitude plot
plt.subplot(2, 2, 1)
plt.title('Magnitude')
plt.xlabel('Frequency [rad/s]')
plt.ylabel('Magnitude [dB]')
plt.grid(which='both', axis='both')
plt.legend()

# Set the titles and labels for the phase plot
plt.subplot(2, 2, 3)
plt.title('Phase')
plt.xlabel('Frequency [rad/s]')
plt.ylabel('Phase [degrees]')
plt.grid(which='both', axis='both')
plt.legend()
plt.rcParams['axes.titlesize'] = 18  # Title font size
plt.rcParams['axes.labelsize'] = 18  # Axis label font size
plt.rcParams['xtick.labelsize'] = 18  # X-axis tick label font size
plt.rcParams['ytick.labelsize'] = 18  # Y-axis tick label font size
plt.rcParams['legend.fontsize'] = 18  # Legend font size

# Adjust layout to prevent overlap
plt.tight_layout()

# Display the plots
plt.show()


