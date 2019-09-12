using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Somme
{
    class Program
    {
        static int Main(string[] args)
        {
            int somme = 0;

            if (args.Length == 0)
            {
                Console.Error.WriteLine("USAGE: Somme [--env] [--help] [--stdin] [nombres...]");
                return 1;
            }

            foreach (string arg in args)
            {
                switch (arg)
                {
                    case "--help":
                        Console.WriteLine("USAGE: Somme [--env] [--help] [--stdin] [nombres...]");
                        return 0;

                    case "--env":
                        for (int i = 0; i < 10; ++i)
                        {
                            string varEnvir = Environment.GetEnvironmentVariable($"NB{i}");

                            if (string.IsNullOrWhiteSpace(varEnvir)) continue;

                            if (int.TryParse(varEnvir, out int variable))
                            {
                                somme += variable;
                            }
                            else
                            {
                                Console.Error.WriteLine($"Le nombre n'est pas valide: {varEnvir}");
                                return 1;
                            }
                        }
                        break;

                    case "--stdin":
                        string réponse = "";

                        while (Console.ReadLine() != "")
                        {
                            réponse += Console.ReadLine();
                        }

                        break;

                    default:
                        if (int.TryParse(arg, out int nombre))
                        {
                            somme += nombre;
                        }
                        else
                        {
                            Console.Error.WriteLine($"Le nombre n'est pas valide: {arg}");
                            return 1;
                        }
                        break;
                }

            }

            Console.WriteLine(somme);
            return 0;
        }
    }
}
