//
//  PreviewData.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import Foundation

let testEvent = Event(id: "1", name: "Neversea", headline: "Best Beach party in Romania", startDate: Date(), endDate: Date(), price: 400, ticket_No: 12000, ticket_Available: 12000, images: ["https://i.ytimg.com/vi/Vc6w--qeLrY/maxresdefault.jpg"], style: "Festival", description: "Lorem Ipsum Dolam eteme", artists: ["KVSH", "Michael Bibi", "Armin Van Burren", "Multi Altii"], genre: "EDM", location: Location(lat: 45.694, lon: 45.934, country: "Romania", county: "Constanta", city: "Constanta", street: "Constanta", no: "20", completeAddress: ""), organiserId: "", reccuring: false, callToActionLink: "", views: 0, isPromoted: true, promotionDate: Date(), venue: "Plaja Mamaia")

let testOrder = Order(id: "1", ticketCode: "8391-1235", userId: "", status: "Available", payment_Status: "Payment Succesful", eventId: "", identifier: "", paymentId: "", paymentTime: Date(), event: testEvent)

let testOrganiser = Organiser(id: "", imageLink: "https://media-exp1.licdn.com/dms/image/C4E0BAQGCsdORHfxq8A/company-logo_200_200/0/1600326640236?e=2159024400&v=beta&t=qX77STRi3UBb3YMKOnnJHXyunlvmv56_IyiC3bb-VVM", name: "Beatact", description: "First App for Techno Parties", role: "Established Organiser", contactEmail: "admin@beatact.net", contactPhone: "+40741252315", website: "www.beatact.net", socialLink: "www.beatact.net", events: [], orders: [], ratings: [], staff: [])

let testUser = User(id: "asdnasidns", name: "Teodor Calin", phone: "+40741252315", email: "teodor.calin@me.com", role: "User", organiserId: nil, stripe_Id: "")

let testCards = [PaymentMethod(id: "iubfisadndoiwn", cardLast4Numbers: "4283", lastUsed: false, exp_year: 2023, exp_month: 12, cardType: "MasterCard"),PaymentMethod(id: "sfsasdsadasdasd", cardLast4Numbers: "1235", lastUsed: false, exp_year: 2043, exp_month: 10, cardType: "Visa")]

let testRating = Rating(id: "123", organiserId: "123123123", userId: "123123123", eventId: "123123123", userName: "John Wick", title: "Atmosfera Buna", text: "Frumoasa locatie, vibe bun, astept cu nerabdare urmatorul eveniment.", stars: 5, datetime: Date())

let testRatings = [testRating,testRating,testRating,testRating,testRating,testRating]
