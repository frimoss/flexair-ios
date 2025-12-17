//
//  CountryModel.swift
//  flexair
//
//  Created by Nikolai on 01/12/2025.
//

import Foundation

struct Country: Identifiable, Codable, Hashable {
    let id: String? // ISO 3166-1 alpha-2
    let name: String
    
    static let all: [Country] = [
        // A
        Country(id: "AF", name: "Afghanistan"),
        Country(id: "AL", name: "Albania"),
        Country(id: "DZ", name: "Algeria"),
        Country(id: "AD", name: "Andorra"),
        Country(id: "AO", name: "Angola"),
        Country(id: "AG", name: "Antigua and Barbuda"),
        Country(id: "AR", name: "Argentina"),
        Country(id: "AM", name: "Armenia"),
        Country(id: "AU", name: "Australia"),
        Country(id: "AT", name: "Austria"),
        Country(id: "AZ", name: "Azerbaijan"),
        
        // B
        Country(id: "BS", name: "Bahamas"),
        Country(id: "BH", name: "Bahrain"),
        Country(id: "BD", name: "Bangladesh"),
        Country(id: "BB", name: "Barbados"),
        Country(id: "BY", name: "Belarus"),
        Country(id: "BE", name: "Belgium"),
        Country(id: "BZ", name: "Belize"),
        Country(id: "BJ", name: "Benin"),
        Country(id: "BT", name: "Bhutan"),
        Country(id: "BO", name: "Bolivia"),
        Country(id: "BA", name: "Bosnia and Herzegovina"),
        Country(id: "BW", name: "Botswana"),
        Country(id: "BR", name: "Brazil"),
        Country(id: "BN", name: "Brunei"),
        Country(id: "BG", name: "Bulgaria"),
        Country(id: "BF", name: "Burkina Faso"),
        Country(id: "BI", name: "Burundi"),
        
        // C
        Country(id: "CV", name: "Cabo Verde"),
        Country(id: "KH", name: "Cambodia"),
        Country(id: "CM", name: "Cameroon"),
        Country(id: "CA", name: "Canada"),
        Country(id: "CF", name: "Central African Republic"),
        Country(id: "TD", name: "Chad"),
        Country(id: "CL", name: "Chile"),
        Country(id: "CN", name: "China"),
        Country(id: "CO", name: "Colombia"),
        Country(id: "KM", name: "Comoros"),
        Country(id: "CG", name: "Congo"),
        Country(id: "CD", name: "Congo (Democratic Republic)"),
        Country(id: "CR", name: "Costa Rica"),
        Country(id: "CI", name: "Côte d'Ivoire"),
        Country(id: "HR", name: "Croatia"),
        Country(id: "CU", name: "Cuba"),
        Country(id: "CY", name: "Cyprus"),
        Country(id: "CZ", name: "Czech Republic"),
        
        // D
        Country(id: "DK", name: "Denmark"),
        Country(id: "DJ", name: "Djibouti"),
        Country(id: "DM", name: "Dominica"),
        Country(id: "DO", name: "Dominican Republic"),
        
        // E
        Country(id: "EC", name: "Ecuador"),
        Country(id: "EG", name: "Egypt"),
        Country(id: "SV", name: "El Salvador"),
        Country(id: "GQ", name: "Equatorial Guinea"),
        Country(id: "ER", name: "Eritrea"),
        Country(id: "EE", name: "Estonia"),
        Country(id: "SZ", name: "Eswatini"),
        Country(id: "ET", name: "Ethiopia"),
        
        // F
        Country(id: "FJ", name: "Fiji"),
        Country(id: "FI", name: "Finland"),
        Country(id: "FR", name: "France"),
        
        // G
        Country(id: "GA", name: "Gabon"),
        Country(id: "GM", name: "Gambia"),
        Country(id: "GE", name: "Georgia"),
        Country(id: "DE", name: "Germany"),
        Country(id: "GH", name: "Ghana"),
        Country(id: "GR", name: "Greece"),
        Country(id: "GD", name: "Grenada"),
        Country(id: "GT", name: "Guatemala"),
        Country(id: "GN", name: "Guinea"),
        Country(id: "GW", name: "Guinea-Bissau"),
        Country(id: "GY", name: "Guyana"),
        
        // H
        Country(id: "HT", name: "Haiti"),
        Country(id: "HN", name: "Honduras"),
        Country(id: "HU", name: "Hungary"),
        
        // I
        Country(id: "IS", name: "Iceland"),
        Country(id: "IN", name: "India"),
        Country(id: "ID", name: "Indonesia"),
        Country(id: "IR", name: "Iran"),
        Country(id: "IQ", name: "Iraq"),
        Country(id: "IE", name: "Ireland"),
        Country(id: "IL", name: "Israel"),
        Country(id: "IT", name: "Italy"),
        
        // J
        Country(id: "JM", name: "Jamaica"),
        Country(id: "JP", name: "Japan"),
        Country(id: "JO", name: "Jordan"),
        
        // K
        Country(id: "KZ", name: "Kazakhstan"),
        Country(id: "KE", name: "Kenya"),
        Country(id: "KI", name: "Kiribati"),
        Country(id: "KP", name: "North Korea"),
        Country(id: "KR", name: "South Korea"),
        Country(id: "KW", name: "Kuwait"),
        Country(id: "KG", name: "Kyrgyzstan"),
        
        // L
        Country(id: "LA", name: "Laos"),
        Country(id: "LV", name: "Latvia"),
        Country(id: "LB", name: "Lebanon"),
        Country(id: "LS", name: "Lesotho"),
        Country(id: "LR", name: "Liberia"),
        Country(id: "LY", name: "Libya"),
        Country(id: "LI", name: "Liechtenstein"),
        Country(id: "LT", name: "Lithuania"),
        Country(id: "LU", name: "Luxembourg"),
        
        // M
        Country(id: "MG", name: "Madagascar"),
        Country(id: "MW", name: "Malawi"),
        Country(id: "MY", name: "Malaysia"),
        Country(id: "MV", name: "Maldives"),
        Country(id: "ML", name: "Mali"),
        Country(id: "MT", name: "Malta"),
        Country(id: "MH", name: "Marshall Islands"),
        Country(id: "MR", name: "Mauritania"),
        Country(id: "MU", name: "Mauritius"),
        Country(id: "MX", name: "Mexico"),
        Country(id: "FM", name: "Micronesia"),
        Country(id: "MD", name: "Moldova"),
        Country(id: "MC", name: "Monaco"),
        Country(id: "MN", name: "Mongolia"),
        Country(id: "ME", name: "Montenegro"),
        Country(id: "MA", name: "Morocco"),
        Country(id: "MZ", name: "Mozambique"),
        Country(id: "MM", name: "Myanmar"),
        
        // N
        Country(id: "NA", name: "Namibia"),
        Country(id: "NR", name: "Nauru"),
        Country(id: "NP", name: "Nepal"),
        Country(id: "NL", name: "Netherlands"),
        Country(id: "NZ", name: "New Zealand"),
        Country(id: "NI", name: "Nicaragua"),
        Country(id: "NE", name: "Niger"),
        Country(id: "NG", name: "Nigeria"),
        Country(id: "MK", name: "North Macedonia"),
        Country(id: "NO", name: "Norway"),
        
        // O
        Country(id: "OM", name: "Oman"),
        
        // P
        Country(id: "PK", name: "Pakistan"),
        Country(id: "PW", name: "Palau"),
        Country(id: "PA", name: "Panama"),
        Country(id: "PG", name: "Papua New Guinea"),
        Country(id: "PY", name: "Paraguay"),
        Country(id: "PE", name: "Peru"),
        Country(id: "PH", name: "Philippines"),
        Country(id: "PL", name: "Poland"),
        Country(id: "PT", name: "Portugal"),
        
        // Q
        Country(id: "QA", name: "Qatar"),
        
        // R
        Country(id: "RO", name: "Romania"),
        Country(id: "RU", name: "Russia"),
        Country(id: "RW", name: "Rwanda"),
        
        // S
        Country(id: "KN", name: "Saint Kitts and Nevis"),
        Country(id: "LC", name: "Saint Lucia"),
        Country(id: "VC", name: "Saint Vincent and the Grenadines"),
        Country(id: "WS", name: "Samoa"),
        Country(id: "SM", name: "San Marino"),
        Country(id: "ST", name: "Sao Tome and Principe"),
        Country(id: "SA", name: "Saudi Arabia"),
        Country(id: "SN", name: "Senegal"),
        Country(id: "RS", name: "Serbia"),
        Country(id: "SC", name: "Seychelles"),
        Country(id: "SL", name: "Sierra Leone"),
        Country(id: "SG", name: "Singapore"),
        Country(id: "SK", name: "Slovakia"),
        Country(id: "SI", name: "Slovenia"),
        Country(id: "SB", name: "Solomon Islands"),
        Country(id: "SO", name: "Somalia"),
        Country(id: "ZA", name: "South Africa"),
        Country(id: "SS", name: "South Sudan"),
        Country(id: "ES", name: "Spain"),
        Country(id: "LK", name: "Sri Lanka"),
        Country(id: "SD", name: "Sudan"),
        Country(id: "SR", name: "Suriname"),
        Country(id: "SE", name: "Sweden"),
        Country(id: "CH", name: "Switzerland"),
        Country(id: "SY", name: "Syria"),
        
        // T
        Country(id: "TJ", name: "Tajikistan"),
        Country(id: "TZ", name: "Tanzania"),
        Country(id: "TH", name: "Thailand"),
        Country(id: "TL", name: "Timor-Leste"),
        Country(id: "TG", name: "Togo"),
        Country(id: "TO", name: "Tonga"),
        Country(id: "TT", name: "Trinidad and Tobago"),
        Country(id: "TN", name: "Tunisia"),
        Country(id: "TR", name: "Turkey"),
        Country(id: "TM", name: "Turkmenistan"),
        Country(id: "TV", name: "Tuvalu"),
        
        // U
        Country(id: "UG", name: "Uganda"),
        Country(id: "UA", name: "Ukraine"),
        Country(id: "AE", name: "United Arab Emirates"),
        Country(id: "GB", name: "United Kingdom"),
        Country(id: "US", name: "United States"),
        Country(id: "UY", name: "Uruguay"),
        Country(id: "UZ", name: "Uzbekistan"),
        
        // V
        Country(id: "VU", name: "Vanuatu"),
        Country(id: "VA", name: "Vatican City"),
        Country(id: "VE", name: "Venezuela"),
        Country(id: "VN", name: "Vietnam"),
        
        // Y
        Country(id: "YE", name: "Yemen"),
        
        // Z
        Country(id: "ZM", name: "Zambia"),
        Country(id: "ZW", name: "Zimbabwe")
    ]
    
    static func search(_ query: String) -> [Country] {
        all.filter {
            $0.name.localizedCaseInsensitiveContains(query) ||
            $0.id!.localizedCaseInsensitiveContains(query)
        }
    }
}
