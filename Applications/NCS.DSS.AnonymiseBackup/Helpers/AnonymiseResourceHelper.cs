using System;
using System.Collections.Generic;
using System.Text;
using NCS.DSS.AnonymiseBackup.Models;
using NCS.DSS.AnonymiseBackup.Models.Resources;
using Newtonsoft.Json;
using Action = NCS.DSS.AnonymiseBackup.Models.Resources.Action;

namespace NCS.DSS.AnonymiseBackup.Helpers
{
    public static class AnonymiseResourceHelper
    {
        private static readonly Random _randomSeed = new Random();

        public static string AnonymiseBackUpData(string fileName, string collectionName, string fileContent)
        {
            if (collectionName == DssResourceNames.Actions)
            {
                List<Action> resource;

                try
                {
                    resource = JsonConvert.DeserializeObject<List<Action>>(fileContent);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    throw;
                }

                return AnonymiseResourceData(resource);
            }

            if (collectionName == DssResourceNames.ActionsPlans)
            {
                List<ActionPlan> resource;

                try
                {
                    resource = JsonConvert.DeserializeObject<List<ActionPlan>>(fileContent);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    throw;
                }
                return AnonymiseResourceData(resource);
            }

            if (collectionName == DssResourceNames.Addresses)
            {
                List<Address> resource;

                try
                {
                    resource = JsonConvert.DeserializeObject<List<Address>>(fileContent);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    throw;
                }

                return AnonymiseResourceData(resource);
            }

            if (collectionName == DssResourceNames.AdviserDetails)
            {
                List<AdviserDetail> resource;

                try
                {
                    resource = JsonConvert.DeserializeObject<List<AdviserDetail>>(fileContent);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    throw;
                }

                return AnonymiseResourceData(resource);
            }

            if (collectionName == DssResourceNames.Contacts)
            {
                List<ContactDetails> resource;

                try
                {
                    resource = JsonConvert.DeserializeObject<List<ContactDetails>>(fileContent);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    throw;
                }

                return AnonymiseResourceData(resource);
            }

            if (collectionName == DssResourceNames.Customers)
            {
                List<Customer> resource;

                try
                {
                    resource = JsonConvert.DeserializeObject<List<Customer>>(fileContent);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    throw;
                }

                return AnonymiseResourceData(resource);
            }

            if (collectionName == DssResourceNames.DiversityDetails)
            {
                List<DiverstityDetails> resource;

                try
                {
                    resource = JsonConvert.DeserializeObject<List<DiverstityDetails>>(fileContent);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    throw;
                }

                return AnonymiseResourceData(resource);
            }

            if (collectionName == DssResourceNames.Goals)
            {
                List<Goal> resource;

                try
                {
                    resource = JsonConvert.DeserializeObject<List<Goal>>(fileContent);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    throw;
                }

                return AnonymiseResourceData(resource);
            }

            if (collectionName == DssResourceNames.Interactions)
            {
                List<Interaction> resource;

                try
                {
                    resource = JsonConvert.DeserializeObject<List<Interaction>>(fileContent);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    throw;
                }

                return AnonymiseResourceData(resource);
            }

            if (collectionName == DssResourceNames.Outcomes)
            {
                List<Outcome> resource;

                try
                {
                    resource = JsonConvert.DeserializeObject<List<Outcome>>(fileContent);
                }
                catch (Exception e)
                {
                    Console.WriteLine("Unable to Deserialize Outcomes Object: " + e);
                    throw;
                }

                return AnonymiseResourceData<Outcome>(resource);
            }

            if (collectionName == DssResourceNames.Sessions)
            {
                List<Session> resource;

                try
                {
                    resource = JsonConvert.DeserializeObject<List<Session>>(fileContent);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    throw;
                }

                return AnonymiseResourceData(resource);
            }

            if (collectionName == DssResourceNames.Subscriptions)
            {
                List<Subscription> resource;

                try
                {
                    resource = JsonConvert.DeserializeObject<List<Subscription>>(fileContent);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    throw;
                }

                return AnonymiseResourceData(resource);
            }

            if (collectionName == DssResourceNames.Transfers)
            {
                List<Transfer> resource;

                try
                {
                    resource = JsonConvert.DeserializeObject<List<Transfer>>(fileContent);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    throw;
                }

                return AnonymiseResourceData(resource);
            }

            if (collectionName == DssResourceNames.WebChats)
            {
                List<WebChat> resource;

                try
                {
                    resource = JsonConvert.DeserializeObject<List<WebChat>>(fileContent);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                    throw;
                }

                return AnonymiseResourceData(resource);
            }

            return null;
        }

        private static string AnonymiseResourceData<T>(List<T> listOfData) where T : IAnonymise
        {
            foreach (var data in listOfData)
            {
                data.SetRandomSeed(_randomSeed);
                data.Anonymise();
            }

            var test = JsonConvert.SerializeObject(listOfData);
            return test;
        }



    }
}
