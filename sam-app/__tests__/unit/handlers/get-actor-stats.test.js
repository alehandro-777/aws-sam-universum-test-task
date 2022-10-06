// Import all functions from get-by-id.js 
const lambda = require('../../../src/handlers/get-actor-stats'); 
// Import dynamodb from aws-sdk 
const db = require('../../../src/db/imdb.js'); 

// This includes all tests for getByIdHandler() 
describe('Test getActorStatsHandler', () => { 
    let getSpy; 
 
    // Test one-time setup and teardown, see more in https://jestjs.io/docs/en/setup-teardown 
    beforeAll(() => { 
        // Mock dynamodb get and put methods 
        // https://jestjs.io/docs/en/jest-object.html#jestspyonobject-methodname 
        getSpy = jest.spyOn(dynamodb.DocumentClient.prototype, 'get'); 
    }); 
 
    // Clean up mocks 
    afterAll(() => { 
        getSpy.mockRestore(); 
    }); 
 
    // This test invokes getByIdHandler() and compare the result  
    it('should get item by id', async () => { 
        const item = {
            actor_id: 123,
            name: 'Kjetil André Aamodt',
            number_of_movies: 1,
            top_genre: 'Documentary',
            number_of_movies_by_genre: '{"Documentary": 1}',
            most_frequent_partner: '{"partner_actor_id": 9045, "partner_actor_name": "Thomas Alsgaard", "number_of_shared_movies": 1}'
          }; 
 
        // Return the specified value whenever the spied get function is called 
        getSpy.mockReturnValue({ 
            promise: () => Promise.resolve(
                    {
                      actor_id: 123,
                      name: 'Kjetil André Aamodt',
                      number_of_movies: 1,
                      top_genre: 'Documentary',
                      number_of_movies_by_genre: '{"Documentary": 1}',
                      most_frequent_partner: '{"partner_actor_id": 9045, "partner_actor_name": "Thomas Alsgaard", "number_of_shared_movies": 1}'
                    }
                ) 
        }); 
 
        const event = { 
            httpMethod: 'GET', 
            pathParameters: { 
                id: '1234' 
            } 
        } 
 
        // Invoke getByIdHandler() 
        const result = await lambda.getActorStatsHandler(event); 
 
        const expectedResult = { 
            statusCode: 200, 
            body: JSON.stringify(item) 
        }; 
 
        // Compare the result with the expected result 
        expect(result).toEqual(expectedResult); 
    }); 
}); 
 