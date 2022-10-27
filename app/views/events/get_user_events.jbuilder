json.array!(@eventData) do |l|
    json.( l, "startDate", "endDate", "eventType", "eventDetails", "userFirstName", "userLastName", "userPhoneNumber", "userPhysicalAddress", "userLatLong", "userPerformance", "eventValue" )
end