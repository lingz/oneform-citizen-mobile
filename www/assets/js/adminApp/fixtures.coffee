#initiate orgs
success = (data, textStatus, jqXHR) ->
	if data.result.length == 0
		postData =
			email: "org@org.org"
			secret: "orgSecret"
			name: "orgName"
			description: "we are org"
			address: "1, Org Str"
			phoneNumber: "0123456789"
		success = (data, textStatus, jqXHR) ->
			console.log("initiated orgs")
			postData =
				_id: data.result._id
				secret: data.result._id
				name: "name"
				description: "first and last name"
				type: "text"
			success = (data, textStatus, jqXHR) ->
				console.log("initiated name field")
			make_request("/fields", "POST", postData, success, null)

			postData =
				_id: data.result._id
				secret: data.result._id
				name: "age"
				description: "age"
				type: "text"
			success = (data, textStatus, jqXHR) ->
				console.log("initiated age field")
			make_request("/fields", "POST", postData, success, null)

			postData =
				_id: data.result._id
				secret: data.result._id
				name: "gender"
				description: "gender"
				type: "radio"
			success = (data, textStatus, jqXHR) ->
				console.log("initiated gender field")
			make_request("/fields", "POST", postData, success, null)

		make_request("/orgs", "POST", postData, success, null)

make_request("/orgs", "GET", '', success, null)

#initiate users
success = (data, textStatus, jqXHR) ->
	if data.result.length == 0
		postData =
			email: "john@smith.com"
			internalId: "js123"
			secret: "userSecret"
			firstName: "John"
			lastName: "Smith"
			phoneNumber: "0123456789"
		success = (data, textStatus, jqXHR) ->
			console.log("initiated users")
		make_request("/users", "POST", postData, success, null)

make_request("/users", "GET", '', success, null)

