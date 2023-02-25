//
//  ContentView.swift
//  CustomTagView
//
//  Created by Seungchul Ha on 2023/02/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		NavigationView {
			Home()
				.navigationTitle("Chips")
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
	
	@State var text: String = ""
	
	@State var chips: [[ChipData]] = []
	
	var body: some View {
		
		VStack(spacing: 35) {
			
			
			ScrollView {
				
				// Chips View...
				LazyVStack(alignment: .leading, spacing: 10) {
					
					// Since We Are Using Indices so We Need to Specify ID.
					ForEach(chips.indices, id: \.self) { index in
						
						HStack {
							
							// Sometimes it asks us to specify Hashable in Data Model
							ForEach(chips[index].indices, id: \.self) { chipIndex in
								Text(chips[index][chipIndex].chipText)
									.fontWeight(.bold)
									.padding(.vertical, 10)
									.padding(.horizontal)
									.background(
	//									Capsule().stroke(Color.black, lineWidth: 1)
										RoundedRectangle(cornerRadius: 5, style: .continuous).stroke(.black, lineWidth: 1)
									)
									.lineLimit(1)
								// Main Logic
									.overlay(
										GeometryReader { reader -> Color in
											
											// By Using MaxX Parameter We Can Use Logic And Determine If Its Exceeds or Not....
											
											let maxX = reader.frame(in: .global).maxX
											
											// Both Paddings = 30 + 30 = 60
											// Plus 10 For Extra...
											
											// Doing Action Only If the Item Exceeds.
											if maxX > UIScreen.main.bounds.width - 70 && !chips[index][chipIndex].isExceeded {
												
												// It is updating to each user interaction...
												print(chipIndex)
												
												DispatchQueue.main.async {
													
													// Toggling That...
													chips[index][chipIndex].isExceeded = true
													
													// Getting Last Item...
													let lastItem = chips[index][chipIndex]
													
													// Removing Item From Current Row...
													// Inserting it as new Item
													chips.append([lastItem])
													chips[index].remove(at: chipIndex)
												}
											}
											
											return Color.clear
										},
										alignment: .trailing
									)
									.clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
									.onTapGesture {
										// Removing Data...
										chips[index].remove(at: chipIndex)
										// If the Inside Array is Empty removing that also...
										if chips[index].isEmpty {
											chips.remove(at: index)
										}
									}
							}
						}
					}
				}
				.padding()
				
			}
			.frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 3)
			// Border...
			.background(
				RoundedRectangle(cornerRadius: 15).stroke(Color.gray.opacity(0.5), lineWidth: 1.5)
			)
			
			TextEditor(text: $text)
				.padding()
			// Border with Fixed Size...
				.frame(height: 150)
				.background(
					RoundedRectangle(cornerRadius: 15).stroke(.gray.opacity(0.5), lineWidth: 1.5)
				)
			
			Button {
				
				// Adding Empty Array if there is Nothing....
				if chips.isEmpty {
					chips.append([])
				}
				
				withAnimation(.default) {
					// Adding Chip To Last Array....
					chips[chips.count - 1].append(ChipData(chipText: text))
					
					// Clearing Old Text In Editor
					text = ""
				}
				
			} label: {
				Text("Add Tag")
					.font(.title2)
					.fontWeight(.semibold)
					.foregroundColor(.white)
					.padding(.vertical, 10)
					.frame(maxWidth: .infinity)
					.background(.purple)
					.cornerRadius(4)
			}
			// Disabling Button When Text is Empty...
			.disabled(text == "")
			.opacity(text == "" ? 0.45 : 1)
		}
		.padding()
	}
}

// Chip Data Model....
struct ChipData: Identifiable {
	var id = UUID().uuidString
	var chipText: String
	// To Stop Auto Update
	var isExceeded = false
}
